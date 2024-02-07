# Dataverse Ansible role

This [Ansible][ansible] role aims to install [Dataverse][dataverse] and its prerequisites.
The role installs Apache, PostgreSQL, GlassFish/Payara and other prerequisites, then deploys Dataverse.

## Quickstart

Running the following commands as root should install the latest released version of Dataverse.

	$ git clone https://github.com/GlobalDataverseCommunityConsortium/dataverse-ansible.git dataverse
	$ ansible-playbook --connection=local -v -i dataverse/inventory dataverse/dataverse.pb -e "@dataverse/defaults/main.yml"

Recent, specific versions of Dataverse (namely, 4.20 and 5.0) may be installed using branches tagged with that version.

## Configuration

Installation, customization, administration, and API documentation can be found in the [Dataverse Guides](http://guides.dataverse.org/en/latest/).

The preparation and configuration using `dataverse-ansible` usually involve modifying or accepting the generic defaults stored in [defaults/main.yml](defaults/main.yml). You'll likely want to modify this file or copy it and edit to suit your needs.

Here follows a few key components that you should strongly consider to address before deploying Dataverse using `dataverse-ansible`:

### Enabling SSL

#### Let's Encrypt and Certbot

In almost all cases, enabling SSL is recommended. Also, it is recommended to obtain a certificate from a CA. [Let's Encrypt](https://letsencrypt.org) provides
free certificates that can be automatically obtained and renewed using for instance [Certbot](https://certbot.eff.org).

Certbot also makes it possible to automatically update the web server so that the certificates are used and that all traffic is forced over `https`.

To utilize Certbot with Let's Encrypt certificates you need to set the following parameters in `defaults/main.yml`:

- `letsencrypt.enabled: true`
- `certbot.email: myname@mydomain`
- `apache.ssl.enabled: true`

#### Other certificates
If you need to set particular certificates, for instance if your organization already has prepared this for you we need to modify the following parameters:

- `apache.ssl.enabled: true`

if using X.509 certificates:

- `apache.ssl.cert: /mypath/mycertificate`
- `apache.ssl.interm: /mypath/mycertificatem`
- `apache.ssl.key: /mypath/myprivatekey`

or if using PEM certificates:

- `apache.ssl.pem.cert: /mypath/mycertificate`
- `apache.ssl.pem.interm: /mypath/mycertificatem`
- `apache.ssl.pem.key: /mypath/myprivatekey`

### Update admin password

Please update `dataverse.adminpass` to a password that follows the standards you or your organization demands. The user name of the admin account is by default `dataverseAdmin`.

### Setting the site url

Make sure you set your site url accordingly using `dataverse.payara.siteurl`. Also, please remember that this needs to be the full url, not just domain. If you only
enter the domain here you will have issues with for instance enabling OAuth 2.0/OpenID Connect authentication etc. Assuming you have already enabled SSL, you should then make 
sure to use something like `dataverse.payara.siteurl: https://dataverse.example.edu` (following the example provided in the Dataverse documentation).

### Full(er) Usage:
Here is an example of how to execute the `dataverse-ansible` role with more adjustable parameters:

	$ git clone https://github.com/GlobalDataverseCommunityConsortium/dataverse-ansible.git dataverse
	$ export ANSIBLE_ROLES_PATH=.
	$ ansible-playbook -i <inventory file> [-u <user>] [-b] [-K] -e "@dataverse/defaults/main.yml" [-v] dataverse/dataverse.pb

| option | expansion                             | required |
| ------ | ------------------------------------- | -------- |
| -b     | Become                                | yes      |
| -K     | asK for elevated privilege password   | yes      |
| -e     | Extra variables file                  | no       |
| -v     | run with Verbosity (up to three Vs)   | no       |

The role currently supports RHEL/Rocky 8 (9 in a branch) and Debian 11/12 with all services running on the same machine, but intends to become OS-agnostic and support multiple nodes for scalability. Pull requests are welcomed in this way.

If you're interested in testing Dataverse locally using [Vagrant][vagrant], you'll want to clone this repository and edit the local port redirects if the http/https ports on your local machine are already in use. Note that the current Vagrant VM template requires [VirtualBox][virtualbox] 5.0+ and will automatically launch the above command within your Vagrant VM.

#### Ansible Tags

It is possible to run certain portions of the playbook to avoid running the entire role using ansible tags. Grab the desired tag from [tasks/main.yml](tasks/main.yml) then re-run the above playbook command, appending:

`--tags "munin"`

**Note:** While Ansible in general strives to achieve role idempotence, the dataverse-ansible role is merely a wrapper for the Dataverse installer, which itself is not idempotent. If you strongly desire that the role be idempotent and would like achieve this via semaphores, pull requests are welcome!

### To test using Vagrant:
	$ git clone https://github.com/GlobalDataverseCommunityConsortium/dataverse-ansible
	$ cd dataverse-ansible
	$ vagrant up

On successful completion of the Vagrant run, you should be able to log in to your test Dataverse as dataverseAdmin using the dataverse_adminpass from tests/group_vars/vagrant.yml using the address:

	http://localhost

If you needed to update the host port in the Vagrantfile due to collision, you'd append it to the URL, for example "http://localhost:8080"

### Key components
* Apache httpd
  * Used as a front-end (proxy) for Glassfish (and Shibboleth, if enabled).
  * Default config location: */etc/httpd/conf.d*
  * `$ systemctl {stop|start|restart|status} httpd.`
* GlassFish server (Java EE application server)
  * Default location: */user/local/payara5*
  * Default config location: */usr/local/payara5/glassfish/domains/domain1/config/domain.xml*
  * `$ systemctl {start|stop|restart|status} payara`
* Solr (indexing)
  * Default schema location: */usr/local/solr/example/solr/collection1/conf/schema.xml*
  * `$ systemctl {start|stop|restart|status} solr`
* Postgres (database)
  * Default data/config location: */var/lib/pgsql/9.6/data/*
  * `$ systemctl {start|stop|restart|status} postgresql-9.6`
  * **Note:** as of this writing, RHEL/Rocky8 are compiled- and will only work with PostgresQL 10+
* Shibboleth
  * Provides an additional authentication provider.
  * Default config location: */etc/shibboleth/shibboleth2.xml*
  * Site-specific and therefore not activated in the default configuration
  * `$ systemctl {start|stop|restart|status} shibd`

## IQSS' Sample Data
The role will populate the Dataverse instance with sample data from [IQSS' Sample Data repo][dataverse-sample-data] if run with the `dataverse.sampledata.enabled` group variable is set to `true`. You may fork this repo and provide your own sampledata by setting the `dataverse.sampledata.repo` and `dataverse.sampledata.branch` group variables.

## Custom Sample Data
The role will, if desired, populate the Dataverse instance with custom sample data, and when simply enabled via the dataverse.custom_sampledata.enabled group variable will create a handful of dataverses, datasets, and users. It will also upload a few small sample files snagged from the Dataverse repository's test subdirectory.

You may supply your own sample data by modifying and/or creating JSON files and/or shell scripts (*.sh) in the appropriate directories:

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
  * `$ systemctl stop payara`
  * `$ dropdb -U postgres dvndb`
  * `$ createdb -U postgres dvndb`
  * `$ psql -U postgres dvndb -f \<source-db-dump-file>`
  * `$ systemctl start payara`
  * `$ curl http://localhost:8080/api/admin/index/clear`
  * `$ curl http://localhost:8080/api/admin/index`

## External Tools and other Features
A number of external tools have been written for Dataverse, and as requested or as noticed they show up in the Ansible role as a boolean group variable. Some are enabled by default:

* [QDR's Dataverse Previewers][dataverse-previewers]
* [WholeTale][wholetale] 

Others are available but disabled by default:

* [Counter Processor][counter-processor]

This is a community effort, written primarily by [Don Sizemore][donsizemore]. The role is under active development - pull requests, suggestions and other contributions are welcome!

[![Build Status](https://travis-ci.org/GlobalDataverseCommunityConsortium/dataverse-ansible.svg?branch=master)](https://travis-ci.org/GlobalDataverseCommunityConsortium/dataverse-ansible)

[ansible]: http://ansible.com
[counter-processor]: https://github.com/IQSS/counter-processor
[dataverse]: https://dataverse.org
[dataverse-sample-data]: https://github.com/IQSS/dataverse-sample-data
[dataverse-previewers]: https://globaldataversecommunityconsortium.github.io/dataverse-previewers/
[iqss]: http://www.iq.harvard.edu
[vagrant]: https://www.vagrantup.com
[virtualbox]: https://www.virtualbox.org
[wholetale]: https://wholetale.org/
