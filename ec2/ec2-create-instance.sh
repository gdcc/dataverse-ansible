#!/bin/bash -e

# For docs, see the "Deployment" page in the Dev Guide.

# repo and branch defaults
REPO_URL_DEFAULT="https://github.com/IQSS/dataverse.git"
BRANCH_DEFAULT="develop"
PEM_DEFAULT=${HOME}
VERBOSE_ARG=""

# rocky linux 9.4 official, us-east-1
AWS_AMI_DEFAULT='ami-09fb459fad4613d55'
# let's stick with rocky 8.9 until ITs pass
#AWS_AMI_DEFAULT='ami-0408f4c4a072e3fb9'

usage() {
  echo "Usage: $0 -b <branch> -r <repo> -p <pem_path> -g <group_vars> -a <dataverse-ansible branch> -i aws_image -u aws_user -s aws_size -t aws_tag -f aws_security group -e aws_profile -l local_log_path -d -v" 1>&2
  echo "default branch is develop"
  echo "default repo is https://github.com/IQSS/dataverse"
  echo "default .pem location is ${HOME}"
  echo "example group_vars may be retrieved from https://raw.githubusercontent.com/GlobalDataverseCommunityConsortium/dataverse-ansible/develop/defaults/main.yml"
  echo "default AWS AMI ID is $AWS_AMI_DEFAULT, find the full list at https://rockylinux.org/ami/"
  echo "default AWS user is rocky"
  echo "default AWS instance size is t3a.large"
  echo "default AWS security group is dataverse-sg"
  echo "local log path will rsync Payara, Jacoco, Maven and other logs back to the specified path"
  echo "-d will destroy ("terminate") the AWS instance once testing and reporting completes"
  echo "-v increases Ansible output verbosity"
  exit 1
}

while getopts ":a:r:b:g:p:i:s:t:f:e:l:dv" o; do
  case "${o}" in
  a)
    DA_BRANCH=${OPTARG}
    ;;
  r)
    REPO_URL=${OPTARG}
    ;;
  b)
    BRANCH=${OPTARG}
    ;;
  g)
    GRPVRS=${OPTARG}
    ;;
  p)
    PEM_PATH=${OPTARG}
    ;;
  i)
    AWS_IMAGE=${OPTARG}
    ;;
  u)
    AWS_USER=${OPTARG}
    ;;
  s)
    AWS_SIZE=${OPTARG}
    ;;
  t)
    TAG=${OPTARG}
    ;;
  f)
    AWS_SG=${OPTARG}
    ;;
  l)
    LOCAL_LOG_PATH=${OPTARG}
    ;;
  e)
    AWS_PROFILE=${OPTARG}
    ;;
  d)
    DESTROY=true
    ;;
  v)
    VERBOSE=true
    ;;
  *)
    usage
    ;;
  esac
done

# test for ansible group_vars
if [ ! -z "$GRPVRS" ]; then
   GVFILE=$(basename "$GRPVRS")
   GVARG="-e @$GVFILE"
   #BRANCH=`grep dataverse_branch $GRPVRS |awk '{print $2}'`
   echo "using $GRPVRS for extra vars"
   echo "deploying $BRANCH from $GRPVRS"
fi

# test for specified GitHub repo
if [ ! -z "$REPO_URL" ]; then
   GVARG+=" -e dataverse_repo=$REPO_URL"
   echo "using repo $REPO_URL"
fi

# test for specified branch
if [ ! -z "$BRANCH" ]; then
   GVARG+=" -e dataverse_branch=$BRANCH"
   echo "building branch $BRANCH"
fi

# if no repo and no group_vars, use default repo
if [ -z "$REPO_URL" ] && [ -z "$GRPVRS" ]; then
   REPO_URL=$REPO_URL_DEFAULT
   echo "using default repo: $REPO_URL"
fi

# if no branch and no group_vars, use default branch
if [ -z "$BRANCH" ] && [ -z "$GRPVRS" ]; then
   BRANCH=$BRANCH_DEFAULT
   echo "using default branch $BRANCH"
fi

# The AMI ID may change in the future and the way to look it up is with the following command, which takes a long time to run:
# aws ec2 describe-images  --owners 'aws-marketplace' --filters 'Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce' --query 'sort_by(Images, &CreationDate)[-1].[ImageId]' --output 'text'
# To use an AMI, one must subscribe to it via the AWS GUI.
# AMI IDs are specific to the region.

if [ ! -z "$AWS_IMAGE" ]; then
   AMI_ID=$AWS_IMAGE
else
   AMI_ID="$AWS_AMI_DEFAULT"
fi 
echo "using $AMI_ID"

if [ -z "$AWS_USER" ]; then
   AWS_USER="rocky"
fi

if [ ! -z "$AWS_SIZE" ]; then
   SIZE=$AWS_SIZE
else
   SIZE="t3a.large"
fi
echo "using $SIZE"

if [ ! -z "$TAG" ]; then
   TAGARG="--tag-specifications ResourceType=instance,Tags=[{Key=name,Value=$TAG}]"
   echo "using tag $TAG"
fi

if [ -z "$AWS_SG" ]; then
   AWS_SG="dataverse-sg"
fi
echo "using $AWS_SG security group"

# default to dataverse-ansible/develop
if [ -z "$DA_BRANCH" ]; then
   DA_BRANCH="develop"
fi

# default to "default" AWS profile
if [ ! -z "$AWS_PROFILE" ]; then
   PROFILE="--profile=$AWS_PROFILE"
   echo "using profile $PROFILE"
fi

# verbosity
if [ ! -z "$VERBOSE" ]; then
   VERBOSE_ARG="-v"
fi

AWS_CLI_VERSION=$(aws --version)
if [[ "$?" -ne 0 ]]; then
  echo 'The "aws" program could not be executed. Is it in your $PATH?'
  exit 1
fi

# don't check for branch if using group_vars
if [ -z "$GRPVRS" ]; then
   if [[ $(git ls-remote --heads $REPO_URL $BRANCH | wc -l) -eq 0 ]]; then
     echo "Branch \"$BRANCH\" does not exist at $REPO_URL"
     usage
     exit 1
   fi
fi

GROUP_CHECK=$(aws $PROFILE ec2 describe-security-groups --group-name $AWS_SG)
if [[ "$?" -ne 0 ]]; then
  echo "Creating security group \"$AWS_SG\"."
  aws $PROFILE ec2 create-security-group --group-name $AWS_SG --description "security group for Dataverse"
  aws $PROFILE ec2 authorize-security-group-ingress --group-name $AWS_SG --protocol tcp --port 22 --cidr 0.0.0.0/0
  aws $PROFILE ec2 authorize-security-group-ingress --group-name $AWS_SG --protocol tcp --port 80 --cidr 0.0.0.0/0
  aws $PROFILE ec2 authorize-security-group-ingress --group-name $AWS_SG --protocol tcp --port 443 --cidr 0.0.0.0/0
  aws $PROFILE ec2 authorize-security-group-ingress --group-name $AWS_SG --protocol tcp --port 8080 --cidr 0.0.0.0/0
fi

# were we passed a pem file?
if [ ! -z "$PEM_PATH" ]; then
  KEY_NAME=`echo $PEM_PATH | sed 's/\.pem//g'`
  echo "using key_name: $KEY_NAME"
elif [ -z "$PEM_PATH" ]; then
  RANDOM_STRING="$(uuidgen | cut -c-8)"
  KEY_NAME="key-$USER-$RANDOM_STRING"
  echo "using key_name: $KEY_NAME"
  PRIVATE_KEY=$(aws $PROFILE ec2 create-key-pair --key-name ~/$KEY_NAME --query 'KeyMaterial' --output text)

  if [[ $PRIVATE_KEY == '-----BEGIN RSA PRIVATE KEY-----'* ]]; then
    PEM_FILE="${HOME}/$KEY_NAME.pem"
    printf -- "$PRIVATE_KEY" >$PEM_FILE
    chmod 400 $PEM_FILE
    echo "Your newly created private key file is \"$PEM_FILE\". Keep it secret. Keep it safe."
    KEY_NAME="${HOME}/$KEY_NAME"
  else
    echo "Could not create key pair. Exiting."
    exit 1
  fi
fi

echo "Creating EC2 instance"
# TODO: Add some error checking for "ec2 run-instances".
INSTANCE_ID=$(aws $PROFILE ec2 run-instances --image-id $AMI_ID --security-groups $AWS_SG $TAGARG --count 1 --instance-type $SIZE --key-name $KEY_NAME --query 'Instances[0].InstanceId' --block-device-mappings '[ { "DeviceName": "/dev/sda1", "Ebs": { "DeleteOnTermination": true, "VolumeSize": 20 } } ]' | tr -d \")
echo "Instance ID: "$INSTANCE_ID

DESTROY_CMD="aws $PROFILE ec2 terminate-instances --instance-ids $INSTANCE_ID"
echo "When you are done, please terminate your instance with:"
echo "$DESTROY_CMD"
echo "giving instance 90 seconds to wake up..."

sleep 90
echo "End creating EC2 instance"

PUBLIC_DNS=$(aws $PROFILE ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[*].Instances[*].[PublicDnsName]" --output text)
PUBLIC_IP=$(aws $PROFILE ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[*].Instances[*].[PublicIpAddress]" --output text)

USER_AT_HOST="$AWS_USER@${PUBLIC_DNS}"
echo "New instance created with ID \"$INSTANCE_ID\". To ssh into it:"
echo "ssh -i $PEM_FILE $USER_AT_HOST"

echo "Please wait at least 15 minutes while the branch \"$BRANCH\" from $REPO_URL is being deployed."

if [ ! -z "$GRPVRS" ]; then
   scp -i $PEM_FILE -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile=/dev/null' -o 'ConnectTimeout=300' $GRPVRS $USER_AT_HOST:$GVFILE
fi

# epel-release is installed first to ensure the latest ansible is installed after
# TODO: Add some error checking for this ssh command.
ssh -T -i $PEM_FILE -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile=/dev/null' -o 'ConnectTimeout=300' $USER_AT_HOST <<EOF
sudo dnf -q -y install epel-release
sudo dnf -q -y install ansible git
git clone -b $DA_BRANCH https://github.com/GlobalDataverseCommunityConsortium/dataverse-ansible.git dataverse
export ANSIBLE_ROLES_PATH=.
ansible-playbook $VERBOSE_ARG -i dataverse/inventory dataverse/dataverse.pb --connection=local $GVARG
EOF

# did AWS go AWOL? Jenkins will check for this file.
ssh-keyscan ${PUBLIC_DNS} >> ~/.ssh/known_hosts
rsync -av -e "ssh -i $PEM_FILE" $AWS_USER@$PUBLIC_DNS:/tmp/ansible_complete ./

if [ ! -z "$LOCAL_LOG_PATH" ]; then
   echo "copying logs to $LOCAL_LOG_PATH."
   # 1 logdir should exist
   mkdir -p $LOCAL_LOG_PATH
   # 2 grab logs for local processing in jenkins
   rsync -av -e "ssh -i $PEM_FILE" --ignore-missing-args $AWS_USER@$PUBLIC_DNS:/opt/dataverse/dataverse/target/site $LOCAL_LOG_PATH/
   rsync -av -e "ssh -i $PEM_FILE" --ignore-missing-args $AWS_USER@$PUBLIC_DNS:/opt/dataverse/dataverse/target/surefire-reports $LOCAL_LOG_PATH/
   # 3 grab mvn.out
   rsync -av -e "ssh -i $PEM_FILE" --ignore-missing-args $AWS_USER@$PUBLIC_DNS:/opt/dataverse/dataverse/mvn.out $LOCAL_LOG_PATH/
   # 4 jacoco
   rsync -av -e "ssh -i $PEM_FILE" --ignore-missing-args $AWS_USER@$PUBLIC_DNS:/opt/dataverse/dataverse/target/coverage-it $LOCAL_LOG_PATH/
   rsync -av -e "ssh -i $PEM_FILE" --ignore-missing-args $AWS_USER@$PUBLIC_DNS:/opt/dataverse/dataverse/target/coverage-reports/jacoco-unit.exec $LOCAL_LOG_PATH/
   rsync -av -e "ssh -i $PEM_FILE" --ignore-missing-args $AWS_USER@$PUBLIC_DNS:/opt/dataverse/dataverse/target/jacoco_merged.exec $LOCAL_LOG_PATH/
   rsync -av -e "ssh -i $PEM_FILE" --ignore-missing-args $AWS_USER@$PUBLIC_DNS:/opt/dataverse/dataverse/target/classes $LOCAL_LOG_PATH/
   rsync -av -e "ssh -i $PEM_FILE" --ignore-missing-args $AWS_USER@$PUBLIC_DNS:/opt/dataverse/dataverse/src $LOCAL_LOG_PATH/
   # 5 server.logs
   rsync -av -e "ssh -i $PEM_FILE" --ignore-missing-args $AWS_USER@$PUBLIC_DNS:/usr/local/payara*/glassfish/domains/domain1/logs/server.log* $LOCAL_LOG_PATH/
   # 6 query_count.out
   rsync -av -e "ssh -i $PEM_FILE" --ignore-missing-args $AWS_USER@$PUBLIC_DNS:/tmp/query_count.out $LOCAL_LOG_PATH/
   # 7 install.out and setup-all.*.log
   rsync -av -e "ssh -i $PEM_FILE" --ignore-missing-args $AWS_USER@$PUBLIC_DNS:/tmp/dvinstall/install.out $LOCAL_LOG_PATH/
   rsync -av -e "ssh -i $PEM_FILE" --ignore-missing-args $AWS_USER@$PUBLIC_DNS:/tmp/dvinstall/setup-all.*.log $LOCAL_LOG_PATH/
fi

# Port 8080 has been added because Ansible puts a redirect in place
# from HTTP to HTTPS and the cert is invalid (self-signed), forcing
# the user to click through browser warnings.
CLICKABLE_LINK="http://${PUBLIC_DNS}"
echo "Branch $BRANCH from $REPO_URL has been deployed to $CLICKABLE_LINK"

if [ -z "$DESTROY" ]; then
   echo "To ssh into the new instance:"
   echo "ssh -i $PEM_FILE $USER_AT_HOST"
   echo "When you are done, please terminate your instance with:"
   echo "$DESTROY_CMD"
   if [ -z "$PEM_PATH" ]; then
       echo "aws $PROFILE ec2 delete-key-pair --key-name $KEY_NAME"
    fi
else
   echo "destroying AWS instance"
   eval $DESTROY_CMD
   if [ -z "$PEM_PATH" ]; then
        aws $PROFILE ec2 delete-key-pair --key-name $KEY_NAME
      fi
   echo "removing EC2 PEM"
   rm -f $PEM_FILE
fi
