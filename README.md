# Dataverse Ansible role

This [Ansible][ansible] role aims to install [Dataverse][dataverse] and its prerequisites.
The role installs PostgreSQL, GlassFish and other prerequisites, then deploys Dataverse.

Installation, customization, administration, and API documentation can be found in the [Dataverse 4 Guides](http://guides.dataverse.org/en/latest/).

The preparation lies in the group_var options (usernames/passwords, whether to install Shibboleth, etc.).  Your \<group_vars_file> may be a set of generic defaults stored in [roles/dataverse/defaults/main.yaml](roles/dataverse/defaults/main.yaml), but you'll likely want to modify this file or copy it and edit to suit your needs.  Then, fire away:

### Usage:
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
  * # systemctl {stop|start|restart|status} httpd.
* GlassFish server (Java EE application server)
  * Default location: */user/local/glassfish4*
  * Default config location: */usr/local/glassfish4/glassfish/domains/domain1/config/domain.xml*
  * # systemctl {start|stop|restart|status} glassfish
* Solr (indexing)
  * Default schema location: */usr/local/solr/example/solr/collection1/conf/schema.xml*
  * # systemctl {start|stop|restart|status} solr
* Postgres (database)
  * Default data/config location: */var/lib/pgsql/9.3/data/*
  * # systemctl {start|stop|restart|status} postgresql-9.3
* Shibboleth
  * Provides capability for an alternative authentication provider.
  * Default config location: */etc/shibboleth/shibboleth2.xml*
  * Site-specific and therefore not activated in the default configuration
  * # systemctl {start|stop|restart|status} shibd

## Replicating Existing Data
If you wish to clone an existing installation, you should perform the following (example uses default user/db names):
* On the source instance server
  * $ pg_dump -U postgres dvndb  >  \<source-db-dump-file>
  * Copy the content directory of the source instance to the content directory of this instance.
* On the target instace server
  * # systemctl stop glassfish
  * $ dropdb -U postgres dvndb
  * $ createdb -U postgres dvndb
  * $ psql -U postgres dvndb -f \<source-db-dump-file>
  * # systemctl start glassfish
  * $ curl http://localhost:8080/api/admin/index/clear
  * $ curl http://localhost:8080/api/admin/index

This is a community effort, only distantly supported by [IQSS][iqss] and includes many improvements from [Tim Dilauro][tdilauro]. The role is under active development - pull requests, suggestions and other contributions are welcome!

[ansible]: http://ansible.com
[dataverse]: https://dataverse.org
[iqss]: http://www.iq.harvard.edu
[tdilauro]: https://github.com/tdilauro/dataverse-ansible-role
[vagrant]: https://www.vagrantup.com
[virtualbox]: https://www.virtualbox.org
