# CLAUDE.md - AI Assistant Guide for dataverse-ansible

## Repository Overview

This repository contains an Ansible role for deploying [Dataverse](https://dataverse.org), an open-source research data repository software. The role automates the installation and configuration of Dataverse and all its prerequisites including Apache, PostgreSQL, Payara (Java application server), Solr, and optional components.

**Project**: UCLA Data Science Center fork of the Global Dataverse Community Consortium's dataverse-ansible
**Role Name**: `dataverse`
**Namespace**: `ucla-data-science-center`
**Primary Maintainer**: UCLA Data Science Center

## Repository Structure

```
dataverse-ansible/
├── defaults/
│   └── main.yml              # Default variables (configuration template)
├── tasks/
│   └── main.yml              # Main task orchestration
│   └── *.yml                 # Individual task files for each component
├── templates/
│   └── *.j2                  # Jinja2 templates for configuration files
├── files/
│   ├── branding/             # Custom branding assets
│   └── sampleusers/          # Sample user data
├── handlers/
│   └── main.yml              # Ansible handlers for service management
├── meta/
│   └── main.yml              # Role metadata
├── molecule/
│   ├── default/              # Molecule test scenarios
│   └── rocky9/               # Rocky Linux 9 test scenario
├── collections/
│   ├── requirements.yml      # Ansible Galaxy collections dependencies
│   └── ansible_collections/  # Vendored collections (community.general, community.postgresql)
├── custom_sampledata/        # Custom sample data for testing
├── tests/                    # Test configurations and sample data
├── group_vars/               # Group-level variables
├── dataverse.pb              # Main playbook (entry point)
├── site.yml                  # Alternative playbook with prerequisites
├── Vagrantfile               # Vagrant configuration for local testing
├── Makefile                  # Bootstrap command for dependencies
├── requirements.txt          # Python dependencies (Ansible, Molecule)
└── UCLA-CONTRIBUTING.md      # UCLA-specific contribution guidelines
```

## Key Components and Technologies

### Core Software Stack
- **Apache HTTP Server**: Frontend proxy server for Dataverse
- **Payara Server**: Java EE application server (default: Payara 6)
- **PostgreSQL**: Database backend (default: version 16)
- **Solr**: Search and indexing (default: version 9.8.0)
- **Dataverse**: Research data repository application (default: version 6.7.1)

### Optional Components
- **Shibboleth**: SAML-based authentication provider
- **R Server (Rserve)**: Statistical analysis integration
- **MinIO/S3**: Object storage backends
- **LocalStack**: Local AWS S3 emulation for development
- **Prometheus/Munin**: Monitoring solutions
- **Let's Encrypt/Certbot**: Automated SSL certificate management

## Configuration System

### Variable Hierarchy
1. **defaults/main.yml**: Base configuration template with all available options
2. **group_vars/**: Group-specific variable overrides
3. **Command-line**: `-e` extra vars at playbook execution

### Critical Configuration Variables

#### Dataverse Core Settings
```yaml
dataverse:
  version: '6.7.1'                    # Dataverse version to install
  adminpass: admin1                   # Admin password (CHANGE THIS!)
  payara:
    siteurl: ""                       # Full URL (e.g., https://dataverse.example.edu)
    user: dataverse
    domain: domain1
  service_email: noreply@dataverse.ucla.edu
  smtp: localhost
```

#### SSL/TLS Configuration
```yaml
apache:
  ssl:
    enabled: false                    # Enable SSL
letsencrypt:
  enabled: false                      # Use Let's Encrypt
  certbot:
    email: ""                         # Required for Let's Encrypt
```

#### Database Settings
```yaml
db:
  postgres:
    enabled: true
    version: 16
    name: dvndb
    user: dvnuser
    pass: dvnsecret                   # CHANGE THIS!
```

#### Storage Configuration
```yaml
dataverse:
  filesdirs:
    - label: file                     # Default storage label
      path: /usr/local/dvn/data       # Default storage path
```

## Development Workflows

### UCLA Branching Strategy

**Base Branch**: `develop` (NOT `main`)

**Branch Naming Conventions**:
- `config/*` - Configuration changes (group_vars, defaults, environment)
- `task/*` - Task/handler/template updates
- `doc/*` - Documentation changes

**Example**:
```bash
git checkout -b config/molecule-vars
# Make changes
git add group_vars/molecule.yml
git commit -m "Add vars for molecule testing"
git push -u origin config/molecule-vars
```

### Testing with Molecule

**Install Dependencies**:
```bash
# Install Python dependencies
pip install -r requirements.txt

# Bootstrap Ansible collections
make bootstrap
# OR manually:
ansible-galaxy collection install -r collections/requirements.yml -p ./collections --force
```

**Run Full Test**:
```bash
molecule test -s rocky9
```

**Iterative Development**:
```bash
molecule create -s rocky9      # Create test VM
molecule converge -s rocky9    # Run playbook
molecule verify -s rocky9      # Run verification
molecule destroy -s rocky9     # Clean up
```

### Local Testing with Vagrant

```bash
vagrant up                     # Starts local VM and runs playbook
vagrant provision              # Re-run provisioning
vagrant ssh                    # SSH into VM
vagrant destroy                # Clean up
```

Access: http://localhost (or http://localhost:8080 if port modified)

## Playbook Execution

### Basic Installation
```bash
ansible-playbook -i inventory dataverse.pb -e "@defaults/main.yml"
```

### With Sudo/Become
```bash
ansible-playbook -i <inventory> -b -K -e "@defaults/main.yml" dataverse.pb
```

### Using Ansible Tags

Run specific components only:
```bash
ansible-playbook -i inventory dataverse.pb --tags "postgres,solr"
ansible-playbook -i inventory dataverse.pb --tags "apache"
ansible-playbook -i inventory dataverse.pb --tags "dataverse"
```

**Common Tags** (see tasks/main.yml for full list):
- `prereqs` - System prerequisites
- `apache` - Apache configuration
- `postgres` - PostgreSQL setup
- `payara` - Payara server
- `solr` - Solr search engine
- `dataverse` - Dataverse application
- `shibboleth` - Shibboleth authentication
- `sampledata` - Sample data loading

## Task Orchestration Flow

The main.yml orchestrates installation in this order:

1. **sanity-checks.yml** - Validate prerequisites
2. **dataverse-prereqs.yml** - Install system dependencies
3. **postfix.yml** - Email server (if enabled)
4. **dataverse-apache.yml** - Apache web server
5. **postgres.yml** - PostgreSQL database
6. **dataverse-installer.yml** - Download Dataverse installer
7. **payara.yml** - Payara application server setup
8. **solr.yml** - Solr search engine
9. **s3.yml/minio.yml/localstack.yml** - Object storage (if enabled)
10. **dataverse-install.yml** - Dataverse application deployment
11. **dataverse-postinstall.yml** - Post-installation configuration
12. **dataverse-gui.yml** - Branding customization (if enabled)
13. **shibboleth.yml** - Authentication provider (if enabled)
14. **sampledata.yml** - Sample data loading (if enabled)
15. **dataverse-previewers.yml** - File preview tools (if enabled)
16. **dataverse-languages.yml** - Language packs (if enabled)

## Key Files and Their Purposes

### Configuration Files
- **defaults/main.yml** (493 lines): Complete configuration template with all options
- **group_vars/all.yml**: Global variable overrides
- **ansible.cfg**: Ansible configuration (sets collections_path)

### Playbooks
- **dataverse.pb**: Main playbook entry point
- **site.yml**: Alternative playbook with prerequisite installation

### Important Task Files
- **tasks/main.yml**: Orchestration master file
- **tasks/dataverse-install.yml**: Core Dataverse installation logic
- **tasks/payara.yml**: Payara server configuration
- **tasks/postgres.yml**: Database setup and configuration
- **tasks/dataverse-apache.yml**: Apache proxy configuration

### Templates
- **templates/default.config.j2**: Payara domain configuration
- **templates/dataverse.conf.j2**: Apache virtual host configuration
- **templates/counter-processor-config.yml.j2**: Usage statistics configuration

## AI Assistant Best Practices

### When Modifying Configuration

1. **Always check defaults/main.yml first** - It's the source of truth for all configurable options
2. **Preserve nested YAML structure** - The configuration uses complex nested dictionaries
3. **Don't commit secrets** - Use placeholder values like `admin1`, `dvnsecret`, `notPr0d`
4. **Test with Molecule** - Run `molecule test -s rocky9` before submitting changes
5. **Update documentation** - If adding new features, update README.md

### When Adding/Modifying Tasks

1. **Use Fully Qualified Collection Names (FQCN)** - e.g., `community.postgresql.postgresql_db` instead of `postgresql_db`
2. **Add appropriate tags** - Match existing tag patterns in tasks/main.yml
3. **Make tasks idempotent** - Tasks should be safely re-runnable
4. **Add `when` conditions** - Respect enable/disable flags from configuration
5. **Use templates for configuration files** - Don't use inline content when complex

### Common Gotchas

1. **Payara vs GlassFish**: This role uses Payara, not GlassFish (older configs may reference GlassFish)
2. **PostgreSQL version**: Default is PostgreSQL 16; RHEL/Rocky 8+ require PostgreSQL 10+
3. **Role idempotence**: The Dataverse installer itself is NOT idempotent
4. **Storage label changes**: Changing `filesdirs.label` after initial install requires database migration
5. **SSL site URL**: Must be full URL including protocol (https://example.com), not just domain
6. **Collections are vendored**: community.general and community.postgresql are stored in `collections/`

### File Editing Guidelines

1. **Task files**: Use FQCN, add tags, include `when` conditionals
2. **Templates**: Use Jinja2 syntax, reference variables from defaults/main.yml
3. **Defaults**: Use clear comments, group related settings, provide examples
4. **Documentation**: Keep README.md, UCLA-CONTRIBUTING.md, and CLAUDE.md in sync

### Testing Strategy

1. **Molecule for comprehensive testing**: Use `molecule test -s rocky9` for full lifecycle
2. **Vagrant for quick local tests**: Use `vagrant up` for rapid iteration
3. **Specific tags for component testing**: Use `--tags` to test individual components
4. **Check logs**: Payara logs in `/usr/local/payara6/glassfish/domains/domain1/logs/`

## Ansible Collections Used

This role uses vendored collections (stored locally in `collections/`):

- **community.general** (v11.2.1): General-purpose modules
- **community.postgresql** (v4.1.0): PostgreSQL management modules

**Bootstrap collections**: `make bootstrap`

## Version Support

### Operating Systems
- RHEL/Rocky Linux 8, 9
- Debian 11, 12
- CentOS 7, 8 (older versions)

### Software Versions (Defaults)
- Dataverse: 6.7.1
- Payara: 6.2025.3
- PostgreSQL: 16
- Solr: 9.8.0
- Java: 17
- Maven: 3.9.11

## Security Considerations

### Secrets Management
- **Never commit real passwords** to the repository
- Default passwords are placeholders: `admin1`, `dvnsecret`, `notPr0d`, etc.
- Use Ansible Vault for production secrets: `ansible-vault encrypt_string`
- Store secrets in separate files referenced by playbook

### SSL/TLS
- **Always enable SSL in production**: `apache.ssl.enabled: true`
- Use Let's Encrypt for free certificates: `letsencrypt.enabled: true`
- Provide valid email for Let's Encrypt: `letsencrypt.certbot.email`

### API Security
- Block admin endpoints in production: `apache.block.admin: true`
- Block builtin-users endpoint: `apache.block.builtin_users: true`
- Configure API blocked endpoints: `dataverse.api.blocked_endpoints`

## Debugging and Troubleshooting

### Service Management
```bash
systemctl status payara
systemctl status postgresql-16
systemctl status solr
systemctl status httpd
```

### Log Locations
- Payara: `/usr/local/payara6/glassfish/domains/domain1/logs/server.log`
- PostgreSQL: `/var/lib/pgsql/16/data/log/`
- Apache: `/var/log/httpd/`
- Solr: `/usr/local/solr/logs/`

### Common Issues
1. **Playbook fails partway through**: Check for failed tasks, review logs
2. **Services won't start**: Check ports, permissions, configuration files
3. **Database connection errors**: Verify PostgreSQL running, check credentials
4. **Solr schema issues**: Ensure Solr running before Dataverse installation

### Verbose Output
```bash
ansible-playbook -vvv dataverse.pb  # Maximum verbosity
```

## Contributing to This Repository

See [UCLA-CONTRIBUTING.md](UCLA-CONTRIBUTING.md) for detailed contribution guidelines.

**Quick Summary**:
- Branch from `develop`
- Use branch prefixes: `config/`, `task/`, `doc/`
- Test with Molecule: `molecule test -s rocky9`
- Keep commits focused and atomic
- Don't commit secrets

## External Resources

- [Dataverse Official Documentation](http://guides.dataverse.org/en/latest/)
- [Dataverse GitHub Repository](https://github.com/IQSS/dataverse)
- [Payara Documentation](https://docs.payara.fish/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Molecule Testing Framework](https://molecule.readthedocs.io/)

## Quick Reference Commands

### Bootstrap Project
```bash
pip install -r requirements.txt
make bootstrap
```

### Run Playbook
```bash
ansible-playbook -i inventory dataverse.pb -e "@defaults/main.yml"
```

### Test with Molecule
```bash
molecule test -s rocky9
```

### Test with Vagrant
```bash
vagrant up
```

### Install Specific Components
```bash
ansible-playbook dataverse.pb --tags "apache,postgres"
```

### Check Variable Configuration
```bash
ansible-playbook dataverse.pb --list-tasks
ansible-playbook dataverse.pb --list-tags
```

---

**Last Updated**: 2025-11-15
**Maintained By**: UCLA Data Science Center
**For Questions**: See existing branches or consult team documentation
