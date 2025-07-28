## Local setup (recommended)

These instructions assume:
- You have already cloned this repository locally:
  ```
  git clone https://github.com/ucla-data-science-center/dataverse-ansible.git
  cd dataverse-ansible
  ```
- You have [Conda](https://docs.conda.io/en/latest/miniconda.html) installed (e.g. via Miniforge or Miniconda).
- Docker is installed and running on your system.

---

### Create the Conda environment

To create a consistent development environment, use the provided `environment.yml` file:

```
conda env create -f environment.yml
conda activate dataverse-ansible
```

This will install Python 3.11, Ansible, Molecule, and Docker bindings.

---

### Alternative: Manual environment creation

If you prefer not to use `environment.yml`, you can create the environment manually:

```
conda create -n dataverse-ansible python=3.11 -y
conda activate dataverse-ansible
conda install -c conda-forge ansible molecule docker-py
```

If you plan to use Vagrant with Molecule instead of Docker, install the vagrant plugin:

```
pip install 'molecule[docker]'
```

---

## Running with Molecule and Docker

The `rocky9` Molecule scenario uses Docker as a provisioner. It relies on a custom image with `systemd` support, allowing `sudo` commands to run inside the container. This avoids modifying the Ansible role's privilege escalation behavior.

From the root of the cloned repository, run:

```
molecule converge --scenario-name rocky9
```

This will build a Docker container, install Dataverse, and configure services.

Once complete, you should be able to access Dataverse at:

```
http://localhost:8080
```

Default admin login:
- **Username**: `dataverseAdmin`
- **Password**: defined in `tests/group_vars/vagrant.yml` (look for `dataverse_adminpass`)

To verify the server is responding:

```
curl -I http://localhost:8080
```

```
HTTP/1.1 302 Found
Server: Payara Server 6.2025.2 #badassfish
X-Powered-By: Servlet/6.0 JSP/3.1 (Payara Server 6.2025.2 #badassfish Java/Red Hat, Inc./17)
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: PUT, GET, POST, DELETE, OPTIONS
Access-Control-Allow-Headers: Accept, Content-Type, X-Dataverse-key, Range
Access-Control-Expose-Headers: Accept-Ranges, Content-Range, Content-Encoding
Set-Cookie: JSESSIONID=23f7765f06c1f42ad21f492b85a6; Path=/;SameSite=Lax;SameSite=Lax
Set-Cookie: csfcfc=6Ped8fcWqtJm0q1f2%2BUzSThNbg%2F8; Path=/; HttpOnly;SameSite=Lax
Location: http://localhost:8080/loginpage.xhtml;jsessionid=23f7765f06c1f42ad21f492b85a6?redirectPage=%2Fdataverse.xhtml
Content-Length: 267
Content-Language: en
Content-Type: text/html;charset=UTF-8
X-Frame-Options: SAMEORIGIN
```

---

## Teardown and Rebuild

Because the Dataverse installer is not idempotent, it’s recommended to fully reset the container between changes.

To stop and delete the container:

```
molecule reset --scenario-name rocky9
```

Then rebuild with `molecule converge`.

To open a shell inside the running container:

```
molecule login --scenario-name rocky9
```

To see additional Molecule commands:

```
molecule --help
```

More documentation: https://ansible.readthedocs.io/projects/molecule/

---

## Notes

- If port `8080` is already in use on your machine, update the port mapping in `molecule/rocky9/molecule.yml`.
- Ensure Docker Desktop or your Linux Docker daemon is running before launching `molecule converge`.

---

## Windows/WSL2 Linux specific changes

If you're using WSL2 with Debian Linux, make the following adjustments (branch: `windows_wsl2_jmj`):

- In `minio.yml`, lines 68 and 79:  
  Change `community.docker.docker_compose` to `community.docker.docker_compose_v2`

- In `tasks/postgres_redhat.yml`, line 11:  
  Change `-aarch64` to `{{ ansible_distribution_major_version }}-x86_64`
