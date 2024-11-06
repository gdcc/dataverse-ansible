# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #config.vm.box = "bento/rockylinux-9"
  config.vm.box = "bento/rockylinux-9-arm64"
  
  config.vm.synced_folder ".", "/vagrant"
  config.vm.synced_folder ".", "/etc/ansible/roles/dataverse"

  config.vm.network :forwarded_port, guest: 80, host: 8880, auto_correct: true # Apache Reverse Proxy to Glassfish
  config.vm.network :forwarded_port, guest: 443, host: 8443, auto_correct: true # Apache Reverse Proxy to Glassfish
  config.vm.network :forwarded_port, guest: 5432, host: 5432, auto_correct: true # Postgres
  config.vm.network :forwarded_port, guest: 6311, host: 6311, auto_correct: true # rserve
  config.vm.network :forwarded_port, guest: 8009, host: 8009, auto_correct: true # Glassfish HTTP Listener
  config.vm.network :forwarded_port, guest: 8080, host: 8080, auto_correct: true # Glassfish API Endpoint
  config.vm.network :forwarded_port, guest: 8181, host: 8181, auto_correct: true # ???
  config.vm.network :forwarded_port, guest: 8983, host: 8983, auto_correct: true # Solr
  config.vm.network :forwarded_port, guest: 9090, host: 9090, auto_correct: true # Prometheus

  config.vm.provision :ansible_local do |ansible|
    ansible.playbook = "site.yml"
    ansible.groups = {
      "dataverse" => %(default),
      "db"        => %(default),
      "rserve"    => %(default),
      "systems"   => %(default),
      "vagrant"   => %(default),
      "web-nodes" => %(default),
    }
    ansible.tags = ENV["ANSIBLE_TAGS"]
    ansible.skip_tags = ENV["ANSIBLE_SKIP_TAGS"]
    ansible.verbose = true
  end

  config.vm.provider "vmware_desktop" do |vmware|
    vmware.vmx["tools.upgrade.policy"] = "manual"
    vmware.gui = false
    vmware.ssh_info_public = true
    vmware.allowlist_verified = true
    vmware.linked_clone = false
    vmware.vmx["ethernet0.virtualdev"] = "vmxnet3"
    vmware.vmx["ethernet1.virtualdev"] = "vmxnet3"
    vmware.vmx["memsize"] = "8192"
    vmware.vmx["numvcpus"] = "4"
  end
end