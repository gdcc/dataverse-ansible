#!/bin/bash
# ec2-deploy-docker-demo.sh: run a released version of Dataverse on a new EC2 instance,
# using the demo compose.yml from the Container Guide:
# https://guides.dataverse.org/en/latest/container/running/demo.html
#
# It downloads docker/compose/demo/compose.yml from the release's tag in IQSS/dataverse,
# pins the Dataverse images to that release, and runs "compose up" with Docker (default)
# or Podman. Nothing is built; for a branch, use ec2-create-instance.sh -c instead.

set -euo pipefail

# rocky linux 9.6 official, us-east-1
AWS_AMI_DEFAULT='ami-08ace1224b75d38c1'
AWS_USER=rocky
SIZE_DEFAULT=t3a.large
VOLUME_SIZE=20
AWS_SG_DEFAULT=dataverse-sg
DEMO_DIR=/opt/dataverse-demo
DOCKER_REPO=https://download.docker.com/linux/centos/docker-ce.repo

usage() {
  cat <<EOF
Usage: $0 [-v <version>] [-m docker|podman] [-e aws_profile] [-s aws_size] [-t aws_tag] [-i aws_image] [-f aws_security_group]

Runs a released version of Dataverse on a new EC2 instance, with the demo compose.yml
from https://guides.dataverse.org/en/latest/container/running/demo.html

  -v  Dataverse release, 6.4 or later, e.g. 6.12.1 (default: the latest release)
  -m  container engine: docker (default) or podman
  -e  AWS profile (default: your default AWS credentials)
  -s  AWS instance size (default: $SIZE_DEFAULT)
  -t  AWS name tag for the instance
  -i  AWS AMI ID (default: $AWS_AMI_DEFAULT, Rocky Linux 9 in us-east-1)
  -f  AWS security group (default: $AWS_SG_DEFAULT; it must allow ports 22 and 8080)
  -h  show this help
EOF
  exit "${1:-1}"
}

VERSION=""
ENGINE=docker
AWS_PROFILE_ARG=""
SIZE=$SIZE_DEFAULT
TAG=""
AMI_ID=$AWS_AMI_DEFAULT
AWS_SG=$AWS_SG_DEFAULT

while getopts ":v:m:e:s:t:i:f:h" o; do
  case "$o" in
  v) VERSION=${OPTARG#v} ;;
  m) ENGINE=$OPTARG ;;
  e) AWS_PROFILE_ARG="--profile=$OPTARG" ;;
  s) SIZE=$OPTARG ;;
  t) TAG=$OPTARG ;;
  i) AMI_ID=$OPTARG ;;
  f) AWS_SG=$OPTARG ;;
  h) usage 0 ;;
  *) usage ;;
  esac
done

case "$ENGINE" in
  docker|podman) ;;
  *) echo "-m must be docker or podman, not \"$ENGINE\"" >&2; exit 1 ;;
esac

if ! command -v aws >/dev/null; then
  echo 'The "aws" program could not be found. Is it in your PATH?' >&2
  exit 1
fi

aws_() {
  # shellcheck disable=SC2086
  aws $AWS_PROFILE_ARG "$@"
}

# --- Check the release before paying for an instance -----------------------

if [ -z "$VERSION" ]; then
  VERSION=$(curl -fsSL https://api.github.com/repos/IQSS/dataverse/releases/latest |
    sed -n 's/.*"tag_name": *"v\{0,1\}\([^"]*\)".*/\1/p')
  if [ -z "$VERSION" ]; then
    echo "Could not find the latest Dataverse release on GitHub; pass one with -v" >&2
    exit 1
  fi
  echo "Latest Dataverse release: $VERSION"
fi

COMPOSE_URL="https://raw.githubusercontent.com/IQSS/dataverse/v$VERSION/docker/compose/demo/compose.yml"
COMPOSE_FILE=$(mktemp)
trap 'rm -f "$COMPOSE_FILE"' EXIT
if ! curl -fsSL "$COMPOSE_URL" -o "$COMPOSE_FILE"; then
  echo "Release $VERSION has no demo compose.yml (looked for $COMPOSE_URL)" >&2
  exit 1
fi

# The compose file always says gdcc/dataverse:latest and gdcc/configbaker:latest.
# Docker Hub tags each release as <version>-noble, so pin the images to the release asked for
# ("Rolling Production" in https://guides.dataverse.org/en/latest/container/app-image.html#supported-image-tags).
# Releases before 6.4 used jammy, and their images are no longer on Docker Hub: the check below stops there.
IMAGE_TAG="$VERSION-noble"
for image in dataverse configbaker; do
  if ! curl -fsS -o /dev/null "https://hub.docker.com/v2/repositories/gdcc/$image/tags/$IMAGE_TAG"; then
    echo "Docker Hub has no gdcc/$image:$IMAGE_TAG image for release $VERSION" >&2
    exit 1
  fi
done
sed -E -i.bak "s#(image:[[:space:]]*gdcc/(dataverse|configbaker)):latest#\1:$IMAGE_TAG#" "$COMPOSE_FILE"
rm -f "$COMPOSE_FILE.bak"
# Spell out docker.io: Podman won't guess the registry of a short name like postgres:17.
# Images that already name a registry (a dot before the first slash) are left alone.
sed -E -i.bak '/image:[[:space:]]*[^[:space:]/]*\.[^[:space:]/]*\//! s#(image:[[:space:]]*)#\1docker.io/#' "$COMPOSE_FILE"
rm -f "$COMPOSE_FILE.bak"
if grep -q 'gdcc/.*:latest' "$COMPOSE_FILE"; then
  echo "Could not pin every gdcc image to $IMAGE_TAG in $COMPOSE_URL:" >&2
  grep -n 'gdcc/.*:latest' "$COMPOSE_FILE" >&2
  exit 1
fi
echo "Dataverse $VERSION, images:"
grep -E 'image:' "$COMPOSE_FILE" | sed -E 's/^[[:space:]]*image:[[:space:]]*/  /'

# --- Create the instance --------------------------------------------------

if ! aws_ ec2 describe-security-groups --group-names "$AWS_SG" >/dev/null 2>&1; then
  echo "Creating security group \"$AWS_SG\""
  aws_ ec2 create-security-group --group-name "$AWS_SG" --description "security group for Dataverse" >/dev/null
  for port in 22 80 443 8080; do
    aws_ ec2 authorize-security-group-ingress --group-name "$AWS_SG" --protocol tcp --port "$port" --cidr 0.0.0.0/0 >/dev/null
  done
fi

KEY_NAME="key-$USER-$(uuidgen | cut -c-8)"
PEM_FILE="$HOME/$KEY_NAME.pem"
aws_ ec2 create-key-pair --key-name "$KEY_NAME" --query KeyMaterial --output text >"$PEM_FILE"
chmod 400 "$PEM_FILE"
echo "Your new private key is $PEM_FILE. Keep it secret. Keep it safe."

TAG_ARGS=()
if [ -n "$TAG" ]; then
  TAG_ARGS=(--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG}]")
fi

echo "Creating a $SIZE instance"
INSTANCE_ID=$(aws_ ec2 run-instances --image-id "$AMI_ID" --instance-type "$SIZE" --count 1 \
  --security-groups "$AWS_SG" --key-name "$KEY_NAME" ${TAG_ARGS[@]+"${TAG_ARGS[@]}"} \
  --block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs":{"DeleteOnTermination":true,"VolumeSize":'"$VOLUME_SIZE"'}}]' \
  --query 'Instances[0].InstanceId' --output text)
DESTROY_CMD="aws $AWS_PROFILE_ARG ec2 terminate-instances --instance-ids $INSTANCE_ID"
echo "Instance ID: $INSTANCE_ID"
echo "When you are done, please terminate it with:"
echo "  $DESTROY_CMD"

aws_ ec2 wait instance-running --instance-ids "$INSTANCE_ID"
PUBLIC_DNS=$(aws_ ec2 describe-instances --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicDnsName' --output text)
USER_AT_HOST="$AWS_USER@$PUBLIC_DNS"
SSH_OPTS=(-i "$PEM_FILE" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 -o LogLevel=ERROR)

echo "Waiting for ssh on $PUBLIC_DNS"
for _ in $(seq 1 30); do
  ssh "${SSH_OPTS[@]}" "$USER_AT_HOST" true 2>/dev/null && break
  sleep 10
done

# --- Install the engine and start Dataverse ----------------------------------

scp -q "${SSH_OPTS[@]}" "$COMPOSE_FILE" "$USER_AT_HOST:compose.yml"

echo "Installing $ENGINE and starting Dataverse $VERSION. This takes about 10 minutes."
ssh -T "${SSH_OPTS[@]}" "$USER_AT_HOST" \
  ENGINE="$ENGINE" DEMO_DIR="$DEMO_DIR" DOCKER_REPO="$DOCKER_REPO" PUBLIC_DNS="$PUBLIC_DNS" bash -s <<'REMOTE'
set -euo pipefail

if [ "$ENGINE" = docker ]; then
  sudo dnf -q -y install dnf-plugins-core
  sudo dnf config-manager --add-repo "$DOCKER_REPO"
  sudo dnf -q -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
  sudo systemctl enable --now docker
else
  # podman compose needs a compose provider; podman-compose comes from EPEL
  sudo dnf -q -y install epel-release
  sudo dnf -q -y install podman podman-compose
  # The demo bind-mounts ./data without SELinux labels (:z); Docker doesn't label containers here, Podman does.
  sudo mkdir -p /etc/containers/containers.conf.d
  printf '[containers]\nlabel = false\n' | sudo tee /etc/containers/containers.conf.d/dataverse-demo.conf >/dev/null
  # Bring back containers that have a restart policy after a reboot
  sudo systemctl enable podman-restart.service
fi

sudo mkdir -p "$DEMO_DIR"
sudo mv ~/compose.yml "$DEMO_DIR/compose.yml"
# compose.yml uses MACHINE_IP for Dataverse's own address (dataverse.siteUrl)
echo "MACHINE_IP=$PUBLIC_DNS" | sudo tee "$DEMO_DIR/.env" >/dev/null

cd "$DEMO_DIR"
sudo "$ENGINE" compose up -d

echo "Waiting for Dataverse to answer (up to 15 minutes)..."
for _ in $(seq 1 90); do
  curl -fs -m 5 http://localhost:8080/api/info/version | grep -q '"status":"OK"' && break
  sleep 10
done
curl -fs -m 5 http://localhost:8080/api/info/version | grep -q '"status":"OK"' || {
  echo "Dataverse did not answer within 15 minutes. Its log:" >&2
  sudo "$ENGINE" logs --tail 40 dataverse >&2 || true
  exit 1
}

# bootstrap creates the root collection and dataverseAdmin, but gives up after 3 minutes.
# If Dataverse took longer than that, run it again.
rc=$(sudo "$ENGINE" wait bootstrap)
if [ "$rc" != "0" ]; then
  echo "bootstrap exited with $rc before Dataverse was ready, running it again"
  sudo "$ENGINE" start -a bootstrap
fi
curl -fs -m 5 -o /dev/null http://localhost:8080/api/dataverses/root || {
  echo "Dataverse is up, but the root collection is missing. See: sudo $ENGINE logs bootstrap" >&2
  exit 1
}
REMOTE

cat <<EOF

Dataverse $VERSION is running at http://$PUBLIC_DNS:8080
Log in as dataverseAdmin with the password admin1.

To ssh into the instance:
  ssh -i $PEM_FILE $USER_AT_HOST
The compose file and the data are in $DEMO_DIR. From there:
  sudo $ENGINE compose stop      stop Dataverse
  sudo $ENGINE compose start     start it again
  sudo $ENGINE compose down      remove the containers (the data in $DEMO_DIR/data is kept)

When you are done, please terminate the instance with:
  $DESTROY_CMD
EOF
