# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "db" do |db|
    db.vm.box = "centos/7"
    db.vm.hostname = 'db'
    db.vm.network "private_network", ip: "192.168.56.101"
    # web.vm.network :forwarded_port, guest: 22, host: 10122, id: "ssh"
    # web.ssh.private_key_path = "/home/savr/.vagrant.d/insecure_private_key"
    # web.ssh.forward_agent = true

    db.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.name = "DB_VM"
    end

    db.vm.provision "shell",  path: "mysql.sh"
  end

  config.vm.define "build" do |build|
    build.vm.box = "centos/7"
    build.vm.hostname = 'build'
    build.vm.network "private_network", ip: "192.168.56.102"
    # db.vm.network :forwarded_port, guest: 22, host: 10222, id: "ssh"
    # db.ssh.private_key_path = "/home/savr/.vagrant.d/insecure_private_key"
    # db.ssh.forward_agent = true

    build.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.name = "BLD_VM"
    end

    build.vm.provision "shell",  path: "build.sh"
  end

  config.vm.define "web" do |web|
    web.vm.box = "centos/7"
    web.vm.hostname = 'web'
    web.vm.network "private_network", ip: "192.168.56.103"
    # db.vm.network :forwarded_port, guest: 22, host: 10222, id: "ssh"
    # db.ssh.private_key_path = "/home/savr/.vagrant.d/insecure_private_key"
    # db.ssh.forward_agent = true

    web.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.name = "WEB_VM"
    db.vm.provision "shell",  path: "web.sh"
    end
  end
  config.vm.provision "shell",  path: "start.sh"
end
