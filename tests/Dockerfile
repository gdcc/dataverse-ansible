FROM rockylinux:8

ENV container docker

# systemd funsies per https://hub.docker.com/r/rockylinux/rockylinux
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install Ansible and some dependencies
RUN yum update -y \
    && yum install -y epel-release \
    && yum install -y \
        ansible \
        deltarpm \
        firewalld \
        git \
        python-firewall \
        sudo \
        unzip \
    && yum clean all

# Enable firewalld
RUN systemctl enable firewalld

VOLUME ["/sys/fs/cgroup"]

ENTRYPOINT ["/usr/lib/systemd/systemd"]

WORKDIR /etc/ansible

ENV ANSIBLE_FORCE_COLOR=1 \
    ANSIBLE_RETRY_FILES_ENABLED=0
