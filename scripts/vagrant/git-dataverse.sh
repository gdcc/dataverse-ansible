#!/bin/bash -e

echo "generating ssh keys"
/usr/bin/mkdir /root/.ssh
/usr/bin/ssh-keygen -t dsa -N "" -f /root/.ssh/id_dsa
/usr/bin/ssh-keygen -t dsa -N "" -f /home/vagrant/.ssh/id_dsa
/usr/bin/chown vagrant /home/vagrant/.ssh/id_dsa

echo "accepting ssh key for 127.0.0.1. don't use localhost because of ssh/ansible."
/usr/bin/ssh-keyscan -H 127.0.0.1 >> /root/.ssh/known_hosts
/usr/bin/ssh-keyscan -H 127.0.0.1 >> /home/vagrant/.ssh/known_hosts
/usr/bin/chown vagrant /home/vagrant/.ssh/known_hosts

echo "copying public key to authorized_keys file"
/usr/bin/cat /root/.ssh/id_dsa.pub >> /home/vagrant/.ssh/authorized_keys
/usr/bin/cat /home/vagrant/.ssh/id_dsa.pub >> /home/vagrant/.ssh/authorized_keys

echo "installing git"
/usr/bin/yum -y install git

echo "punching firewall holes for common dataverse ports"
/usr/bin/firewall-cmd --permanent --add-port=80/tcp --zone=public
/usr/bin/firewall-cmd --permanent --add-port=443/tcp --zone=public
/usr/bin/firewall-cmd --permanent --add-port=8080/tcp --zone=public
/usr/bin/firewall-cmd --reload

echo "cloning dataverse-ansible repository"
/usr/bin/git clone https://github.com/IQSS/dataverse-ansible.git /home/vagrant/dataverse-ansible

echo "running dataverse-ansible playbooks"
/usr/bin/ansible-playbook -i /home/vagrant/dataverse-ansible/inventories/vagrant.yaml -s -e @/home/vagrant/dataverse-ansible/group_vars/vagrant.vars -vv /home/vagrant/dataverse-ansible/dataverse.yaml
