## Local Setup (Recommended)

These instructions assume:

- You have already cloned this repository locally:

    ```bash
    git clone https://github.com/ucla-data-science-center/dataverse-ansible.git
    cd dataverse-ansible
    ```

- You have [Conda](https://docs.conda.io/en/latest/miniconda.html) installed (e.g. via [Miniforge](https://github.com/conda-forge/miniforge)).
- Docker is installed and running on your system.

---

### 1. Create the Conda Environment

To create a consistent development environment using `pip-tools`:

    ```bash
    conda env create -f environment.yml
    conda activate dataverse-ansible
    ```

This will install:

- Python 3.11
- `pip-tools` (to manage Python packages via lockfiles)

---

### 2. Compile and Install Python Dependencies

This project uses [`pip-tools`](https://pip-tools.readthedocs.io/) for dependency management. After activating the environment:

    ```bash
    pip-compile requirements.in
    pip-sync
    ```

This will install:

- `ansible-core`
- `molecule`
- `molecule-docker`
- `docker` (Python SDK)

> You only need to run `pip-compile` again if `requirements.in` changes. Use `pip-sync` to reinstall the locked dependencies.

---

### Optional: Manual Environment Creation

If you prefer not to use `environment.yml` or `pip-tools`, you can manually create and install dependencies:

    ```bash
    conda create -n dataverse-ansible python=3.11 -y
    conda activate dataverse-ansible
    pip install ansible-core molecule molecule-docker docker
    ```

---

## Running with Molecule and Docker

The `rocky9` Molecule scenario uses Docker as a provisioner. It relies on a custom image with `systemd` support, allowing `sudo` commands to run inside the container. This avoids modifying the Ansible role's privilege escalation behavior.

From the root of the cloned repository, run:

    ```bash
    molecule converge --scenario-name rocky9
    ```

This will build a Docker container, install Dataverse, and configure services.

Once complete, you should be able to access Dataverse at:

    http://localhost:8080

**Default admin login:**

- **Username**: `dataverseAdmin`
- **Password**: defined in `tests/group_vars/vagrant.yml` (see `dataverse_adminpass`)

To verify the server is responding:

    ```bash
    curl -I http://localhost:8080
    ```

---

## Teardown and Rebuild

Because the Dataverse installer is not idempotent, it’s recommended to fully reset the container between changes.

To stop and delete the container:

    ```bash
    molecule reset --scenario-name rocky9
    ```

Then rebuild with:

    ```bash
    molecule converge --scenario-name rocky9
    ```

To open a shell inside the running container:

    ```bash
    molecule login --scenario-name rocky9
    ```

To see additional Molecule commands:

    ```bash
    molecule --help
    ```

More documentation: [https://ansible.readthedocs.io/projects/molecule/](https://ansible.readthedocs.io/projects/molecule/)

---

## Notes

- If port `8080` is already in use on your machine, update the port mapping in `molecule/rocky9/molecule.yml`.
- Ensure Docker Desktop (macOS) or the Docker daemon (Linux/WSL2) is running before launching `molecule converge`.

---
