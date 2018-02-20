# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # --- VM with Databases --- #
  config.vm.define "db" do |db|
    db.vm.box = "centos/7"
    db.vm.hostname = 'db.local'
    db.vm.network "private_network", ip: "192.168.56.150"
    # web.vm.network :forwarded_port, guest: 22, host: 10122, id: "ssh"
    # web.ssh.private_key_path = "/home/savr/.vagrant.d/insecure_private_key"
    # web.ssh.forward_agent = true

    db.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.name = "DB_VM"
    end

    db.vm.provision "shell",  path: "mysql.sh"
    #db.vm.provision "shell", path: "pgsql.sh"
  end

  # --- VM for application build ---
  config.vm.define "build" do |build|
    build.vm.box = "centos/7"
    build.vm.hostname = 'jenkins.local'
    build.vm.network "private_network", ip: "192.168.56.170"
    # db.vm.network :forwarded_port, guest: 22, host: 10222, id: "ssh"
    # db.ssh.private_key_path = "/home/savr/.vagrant.d/insecure_private_key"
    # db.ssh.forward_agent = true

    build.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.name = "BLD_VM"
    end

    build.vm.provision "shell",  path: "build.sh"
  end

  # --- VM with SonarQube --- #
  config.vm.define "sonar" do |sonar|
    web.vm.box = "centos/7"
    web.vm.hostname = 'sonar.local'
    web.vm.network "private_network", ip: "192.168.56.180"
    # db.vm.network :forwarded_port, guest: 22, host: 10222, id: "ssh"
    # db.ssh.private_key_path = "/home/savr/.vagrant.d/insecure_private_key"
    # db.ssh.forward_agent = true

    web.vm.provider "virtualbox" do |vb|
      vb.memory = "2500"
      vb.name = "WEB_VM"
    end

    web.vm.provision "shell",  path: "sonar.sh"

  # --- MV for deploy --- #
  config.vm.define "web" do |web|
    web.vm.box = "centos/7"
    web.vm.hostname = 'web.local'
    web.vm.network "private_network", ip: "192.168.56.160"
    # db.vm.network :forwarded_port, guest: 22, host: 10222, id: "ssh"
    # db.ssh.private_key_path = "/home/savr/.vagrant.d/insecure_private_key"
    # db.ssh.forward_agent = true

    web.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.name = "WEB_VM"
    end

    # --- MV with Local Repository ---
    config.vm.define "repo" do |repo|
      repo.vm.box = "centos/7"
      repo.vm.hostname = "repo.local"
      repo.vm.provision "shell",  path: "repo.sh"
      repo.vm.provider "virtualbox" do |vb|
        vb.memory = "512"
        vb.name = "RepoVM"
      end
      # web.vm.hostname = 'web'
      repo.vm.network "private_network", ip: "192.168.56.191"
      #repo.vm.network :forwarded_port, guest: 22, host: 10122, id: "ssh"
      # web.ssh.private_key_path = "/home/savr/.vagrant.d/insecure_private_key"
      # web.ssh.forward_agent = true
    end

    web.vm.provision "shell",  path: "web.sh"
  end
  config.vm.provision "shell",  path: "start.sh"
end
