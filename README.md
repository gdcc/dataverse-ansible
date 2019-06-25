# Dataverse Ansible role

This [Ansible][ansible] role aims to install [Dataverse][dataverse] and its prerequisites.
The role installs PostgreSQL, GlassFish and other prerequisites, then deploys Dataverse.

## Quickstart

Running the following commands as root should install the latest released version of Dataverse.

	$ git clone https://github.com/IQSS/dataverse-ansible.git dataverse
	$ ansible-playbook --connection=local -v -i dataverse/inventory dataverse/dataverse.pb -e dataverse/defaults/main.yml

## Configuration

Installation, customization, administration, and API documentation can be found in the [Dataverse 4 Guides](http://guides.dataverse.org/en/latest/).

The preparation lies in the group_var options (usernames/passwords, whether to install Shibboleth, etc.).  Your \<group_vars_file> may be a set of generic defaults stored in [roles/dataverse/defaults/main.yml](roles/dataverse/defaults/main.yml), but you'll likely want to modify this file or copy it and edit to suit your needs.  Then, fire away:

### Usage:
	$ git clone https://github.com/IQSS/dataverse-ansible.git dataverse
	$ export ANSIBLE_ROLES_PATH=.
	$ ansible-playbook -i <inventory file> [-u <user>] [-b] [-K] -e @<group_vars_file> [-v] dataverse.pb

The role currently supports CentOS 7 with all services running on the same machine, but intends to become OS-agnostic and support multiple nodes for scalability.

If you're interested in testing Dataverse locally using [Vagrant][vagrant], you'll want to clone this repository and edit the local port redirects if the http/https ports on your local machine are already in use. Note that the current Vagrant VM template requires [VirtualBox][virtualbox] 5.0 and will automatically launch the above command within your Vagrant VM.

### To test using Vagrant:
	$ git clone https://github.com/IQSS/dataverse-ansible
	$ cd dataverse-ansible
	$ vagrant up

On successful completion of the Vagrant run, you should be able to log in to your test Dataverse as dataverseAdmin using the dataverse_adminpass from group_vars/vagrant.vars using the address:

	http://localhost

If you needed to update the host port in the Vagrantfile due to collision, you'd append it to the URL, for example "http://localhost:8080"

### Key components
* Apache httpd
  * Used as a front-end (proxy) for Glassfish (and Shibboleth, if enabled).
  * Default config location: */etc/httpd/conf.d*
  * `$ systemctl {stop|start|restart|status} httpd.`
* GlassFish server (Java EE application server)
  * Default location: */user/local/glassfish4*
  * Default config location: */usr/local/glassfish4/glassfish/domains/domain1/config/domain.xml*
  * `$ systemctl {start|stop|restart|status} glassfish`
* Solr (indexing)
  * Default schema location: */usr/local/solr/example/solr/collection1/conf/schema.xml*
  * `$ systemctl {start|stop|restart|status} solr`
* Postgres (database)
  * Default data/config location: */var/lib/pgsql/9.6/data/*
  * `$ systemctl {start|stop|restart|status} postgresql-9.6`
* Shibboleth
  * Provides an additional authentication provider.
  * Default config location: */etc/shibboleth/shibboleth2.xml*
  * Site-specific and therefore not activated in the default configuration
  * `$ systemctl {start|stop|restart|status} shibd`

## Sample Data
The role will, if desired, populate the Dataverse instance with sample data, and when simply enabled via the dataverse.sampledata.enabled group variable, will create a handful of dataverses, datasets, and users. It will also upload a few small sample files snagged from the Dataverse repository's test subdirectory.

You may, however, supply your own sample data by modifying and/or creating JSON files and/or shell scripts (*.sh) in the appropriate directories:

	tests/sampledata/dataverses: JSON
	tests/sampledata/users: JSON + shell script(s) to create users
	tests/sampledata/datasets: JSON + shell script(s) to create datasets
	tests/sampledata/files: data files + shell scripts(s) to upload them

The idea was to provide basic sample data yet allow for customization. The role searches the above directories and acts on the contents. Feel free to substitute your own sampledata, and even more free to submit improvements via pull request!

## Replicating Existing Data
If you wish to clone an existing installation, you should perform the following (example uses default user/db names):
* On the source instance server
  * $ pg_dump -U postgres dvndb  >  \<source-db-dump-file>
  * Copy the content directory of the source instance to the content directory of this instance.

* On the target instace server:
  * `$ systemctl stop glassfish`
  * `$ dropdb -U postgres dvndb`
  * `$ createdb -U postgres dvndb`
  * `$ psql -U postgres dvndb -f \<source-db-dump-file>`
  * `$ systemctl start glassfish`
  * `$ curl http://localhost:8080/api/admin/index/clear`
  * `$ curl http://localhost:8080/api/admin/index`

This is a community effort, written primarily by [Don Sizemore][donsizemore]. The role is under active development - pull requests, suggestions and other contributions are welcome!

[![Build Status](https://travis-ci.org/IQSS/dataverse-ansible.svg?branch=master)](https://travis-ci.org/IQSS/dataverse-ansible)

[ansible]: http://ansible.com
[dataverse]: https://dataverse.org
[iqss]: http://www.iq.harvard.edu
[vagrant]: https://www.vagrantup.com
[virtualbox]: https://www.virtualbox.org
