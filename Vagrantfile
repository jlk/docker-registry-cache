VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "williamyeh/ubuntu-trusty64-docker"
  # I use vagrant-vbguest, but don't want it to update by default
  config.vbguest.auto_update = false
  config.vm.synced_folder ".", "/vagrant"
  config.vm.hostname = "hubproxy"

  # Currently I don't think the cache needs a lot of resources...
  config.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
  end

  config.vm.network "private_network", ip: "192.168.99.50", virtualbox__intnet: false

  # the provision_registry_proxy.sh script pulls and runs the registry container
  config.vm.provision "shell", path: "provision_registry_proxy.sh"

end
# -*- mode: ruby -*-
# vi: set ft=ruby :
