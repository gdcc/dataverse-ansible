# EC2 Scripts for use with dataverse-ansible

These scripts, initially written by @matthew-a-dunlap, use the dataverse-ansible role to stand up a functioning Dataverse instance on a single instance in EC2. One may simply provide a branch and/or GitHub repo as arguments, or one may run using the full set of features and options available from dataverse-ansible by providing a "group vars".yml file as an argument.

### Prerequisites:

An **AWS client** and account with access to create EC2 instances as documented at [http://guides.dataverse.org/en/latest/developers/deployment.html#deploying-dataverse-to-amazon-web-services-aws](http://guides.dataverse.org/en/latest/developers/deployment.html#deploying-dataverse-to-amazon-web-services-aws)

If you intend to use the `-l` logpath argument, you will need **rsync version 3.1.0 or above**. *(OS X users: install a newer rsync with brew or macports)*

An existing AWS **security group** to allow network access, typically ports 22, 80, 443, and/or 8080 depending on your needs. A group name of `dataverse-sg` is currently hard-coded in the script. If one uses script defaults, the security group should allow ports 22 and 80; container mode (`-c`) needs ports 22 and 8080.

### Full Usage:

`./ec2-create-instance.sh -b <branch> -r <repo> -p <pem_dir> -g <group_vars> -a <dataverse-ansible branch> -i aws_image -s aws_size -t aws_tag -l local_log_path -c -d`

* the default branch is `develop`
* the default repo is `https://github.com/IQSS/dataverse`
* the default .pem location is the user home directory
* example group_vars may be retrieved from [https://raw.githubusercontent.com/GlobalDataverseCommunityConsortium/dataverse-ansible/develop/defaults/main.yml](https://raw.githubusercontent.com/GlobalDataverseCommunityConsortium/dataverse-ansible/develop/defaults/main.yml)
* the default AWS AMI ID is ami-043ceee68871e0bb5 *(Rocky 8 in us-east-1)* ; full list at https://rockylinux.org/ami/
* the default AWS size is t2.xlarge to avoid OoM killer during integration tests (otherwise, t2.large or even t2.medium may be fine)
* local log path will rsync Payara, Jacoco, Maven and other logs back to the specified path
* `-c` runs Dataverse in containers instead of installing it on the instance; see [Container Mode](#container-mode) below
* `-d` will destroy (terminate) the AWS instance once testing, reporting, and log-copying completes

### Quick Start

To stand up an instance running the latest release of Dataverse, simply run the script:

`./ec2-create-instance.sh`

To stand up an instance running the [develop](https://github.com/IQSS/dataverse/tree/develop) branch from [IQSS](https://github.com/IQSS/dataverse) with [no integration tests](http://guides.dataverse.org/en/latest/developers/testing.html#integration-tests):

`./ec2-create-instance.sh -b develop`

To stand up the `5292-small-container branch` from @poikilotherm's fork:

`./ec2-create.instance.sh -b 5292-small-container -r https://github.com/poikilotherm/dataverse.git`

To stand up an instance from current develop with unit and integration tests enabled, as run on [https://jenkins.dataverse.org/](https://jenkins.dataverse.org/) grab a current copy of [jenkins.yml](https://raw.githubusercontent.com/GlobalDataverseCommunityConsortium/dataverse-ansible/develop/tests/group_vars/jenkins.yml) and issue:

`./ec2-create-instance.sh -g jenkins.yml -l logs`

### Container Mode

With `-c`, the instance builds all of the Dataverse container images (base, app and configbaker) from the chosen branch and starts the stack defined in the branch's `docker-compose-dev.yml`, the same containers developers run on their own computers. Nothing is pulled from a registry for Dataverse itself, so the instance runs exactly the code in the branch (with `develop` merged in, as in classic mode).

To stand up `develop` in container mode:

`./ec2-create-instance.sh -c`

or a branch from a fork:

`./ec2-create-instance.sh -c -b <branch> -r <repo>`

Building the images takes a while: expect about 30 minutes. In container mode the default AWS size is t3a.xlarge with a 30 GB disk; `-s` still overrides the size. When it's done, the script prints a link on port 8080. Log in as `dataverseAdmin` with the password `admin1`.

On the instance, the `dvctl` command starts, stops and checks the containers:

| Command | What it does |
|---|---|
| `dvctl start` | Start Dataverse, wait until it answers and print its address |
| `dvctl stop` | Stop the containers; they are kept, so the next start is quick |
| `dvctl destroy` | Remove the containers |
| `dvctl recreate` | Remove the containers and create new ones, e.g. after editing `docker-compose-dev.yml` |
| `dvctl status` | List the containers and whether Dataverse answers |
| `dvctl version` | Show the deployed branch, commit and Dataverse version |
| `dvctl help` | Show the help |

The database, Solr index and uploaded files are kept in `/opt/dataverse/dataverse/docker-dev-volumes` and survive all of these commands. The checkout, including `docker-compose-dev.yml`, is in `/opt/dataverse/dataverse`.

You can also run it from your own computer over SSH, e.g. `ssh -i <pem> rocky@<host> dvctl status`.

If you stop the EC2 instance to save money and start it again later, run `dvctl start` (or `dvctl status` to check). The instance also gets a new public address.

### Demo of a Release: ec2-deploy-docker-demo.sh

`ec2-create-instance.sh` is for developers: it deploys a branch. To try out a released version of Dataverse instead, `ec2-deploy-docker-demo.sh` runs it on a new EC2 instance with the demo `compose.yml` from the [Container Guide](https://guides.dataverse.org/en/latest/container/running/demo.html). It doesn't use Ansible and builds nothing:

1. It downloads `docker/compose/demo/compose.yml` from the release's tag in [IQSS/dataverse](https://github.com/IQSS/dataverse).
2. That file always uses the `latest` images, so the script pins `gdcc/dataverse` and `gdcc/configbaker` to the release's [`<version>-noble` tag](https://guides.dataverse.org/en/latest/container/app-image.html#supported-image-tags).
3. It creates the instance, installs Docker (or Podman) and runs `compose up -d`.

Releases 6.4 and later are supported. The script checks the release before it creates the instance.

To run the latest release:

`./ec2-deploy-docker-demo.sh`

A specific release, with Podman instead of Docker:

`./ec2-deploy-docker-demo.sh -v 6.11 -m podman`

Options:

* `-v` Dataverse release, e.g. `6.12.1` (default: the latest release)
* `-m` container engine: `docker` (default) or `podman`
* `-e` AWS profile (default: your default AWS credentials)
* `-s` AWS instance size (default: t3a.large)
* `-t` AWS name tag for the instance
* `-i` AWS AMI ID (default: Rocky Linux 9 in us-east-1)
* `-f` AWS security group (default: `dataverse-sg`; it must allow ports 22 and 8080)

It takes about 10 minutes. The script then prints a link on port 8080 (log in as `dataverseAdmin` with the password `admin1`), the ssh command, and the commands to terminate the instance and delete the key pair it created.

On the instance, the compose file and the data are in `/opt/dataverse-demo`. From there, with `podman` in place of `docker` if you used `-m podman`:

* `sudo docker compose stop` stops Dataverse
* `sudo docker compose start` starts it again
* `sudo docker compose down` removes the containers; the data in `/opt/dataverse-demo/data` is kept
* `sudo docker compose logs -f dataverse` follows the Dataverse log

As in the Container Guide, this is a setup for demos and evaluations, not for production.

### Paying the Piper

To see how many instances you or others in your organization have in use, one may:

`./ec2-list-all.sh`

Using the generated image ID one may then terminate a given image:

`aws ec2 terminate-instances --instance-ids <i-nnnnnnnnnnnnnnn>`

or, if absolutely certain:

`./ec2-destroy-all.sh`

which will terminate all instances which do not have "termination protection" enabled.
