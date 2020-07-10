# EC2 Scripts for use with dataverse-ansible

These scripts, initially written by @madunlap, use the dataverse-ansible role to stand up a functioning Dataverse instance on a single instance in EC2. One may simply provide a branch and/or GitHub repo as arguments, or one may run using the full set of features and options available from dataverse-ansible by providing a "group vars".yml file as an argument.

### Prerequisites:

An **AWS client** and account with access to create EC2 instances as documented at [http://guides.dataverse.org/en/latest/developers/deployment.html#deploying-dataverse-to-amazon-web-services-aws](http://guides.dataverse.org/en/latest/developers/deployment.html#deploying-dataverse-to-amazon-web-services-aws)

If you intend to use the `-l` logpath argument, you will need **rsync version 3.1.0 or above**. *(OS X users: install a newer rsync with brew or macports)*

An existing AWS **security group** to allow network access, typically ports 22, 80, 443, and/or 8080 depending on your needs. A group name of `dataverse-sg` is currently hard-coded in the script. If one uses script defaults, the security group should allow ports 22 and 80.

### Usage:

`./ec2-create-instance.sh -b <branch> -r <repo> -p <pem_dir> -g <group_vars> -a <dataverse-ansible branch> -i aws_image -s aws_size -t aws_tag -l local_log_path -d`

* the default branch is `develop`
* the default repo is `https://github.com/IQSS/dataverse`
* the default .pem location is the user home directory
* example group_vars may be retrieved from [https://raw.githubusercontent.com/GlobalDataverseCommunityConsortium/dataverse-ansible/master/defaults/main.yml](https://raw.githubusercontent.com/GlobalDataverseCommunityConsortium/dataverse-ansible/master/defaults/main.yml)
* the default AWS AMI ID is ami-01ca03df4a6012157 *(CentOS 8 in us-east-1)*
* the default AWS size is t2.xlarge to avoid OoM killer during integration tests (otherwise, t2.large or even t2.medium may be fine)
* local log path will rsync Payara, Jacoco, Maven and other logs back to the specified path
* `-d` will destroy (terminate) the AWS instance once testing, reporting, and log-copying completes

### Examples

To stand up an instance on the [develop](https://github.com/IQSS/dataverse/tree/develop) branch from [IQSS](https://github.com/IQSS/dataverse) with [no integration tests](http://guides.dataverse.org/en/latest/developers/testing.html#integration-tests):

`./ec2-create-instance.sh`

To stand up the `5292-small-container branch` from @poikilotherm's fork:

`./ec2-create.instance.sh -b 5292-small-container -r https://github.com/poikilotherm/dataverse.git`

To stand up an instance from current develop with unit and integration tests enabled, as run on [https://jenkins.dataverse.org/](https://jenkins.dataverse.org/) grab a current copy of [jenkins.yml](https://raw.githubusercontent.com/GlobalDataverseCommunityConsortium/dataverse-ansible/master/tests/group_vars/jenkins.yml) and issue:

`./ec2-create-instance.sh -g jenkins.yml -l logs`

### Paying the Piper

To see how many instances you or others in your organization have in use, one may:

`./ec2-list-all.sh`

Using the generated image ID one may then terminate a given image:

`aws ec2 terminate-instances --instance-ids <i-nnnnnnnnnnnnnnn>`

or, if absolutely certain:

`./ec2-destroy-all.sh`

which will terminate all instances which do not have "termination protection" enabled.