## Running with molecule and docker 

The scenario rocky9 uses docker as a provisioner. It uses an image that sets up systemd, so we can use sudo in docker (by default docker doesn't need sudo b/c it runs as root).
This makes us not have to change much of the ansible role to accomodate for that (e.g. when the role switches to sudo to do things). 

To run the build for the first time: 

`molecule converge --scenario-name rocky9`

If you run it successfully, you should access dataverse at http://localhost:8080. 

To teardown the build, run: 

`molecule reset --scenario-name rocky9`

This will stop and delete the docker container. Since the ansible roles isn't idempotent, we typically need to destroy the container and rebuild when we make changes. 

To get a sense of what molecule provides run it without a command and it will list the help menu. For instance, 

`molecule login --scenario-name rocky9` 

Will ssh into the container. The ansible molecule documentation can be found here: https://ansible.readthedocs.io/projects/molecule/

## Windows/WSL2 Linux specific changes
Running on WSL2, Debian Linux  
Created a local branch:  windows_wsl2_jmj  

- **minio.yml**, lines 68, 79  community.docker.docker_compose to community.docker.docker_compose_v2    
- **/tasks/postgres_redhat.yml**, line 11 from -aarch64to ansible_distribution_major_version }}-x86_64  





