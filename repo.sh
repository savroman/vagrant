#!/bin/bash

###### START INSTALLATION ######

# -- add tools --
APPS=(httpd createrepo yum-utils)

# -- create log file --
LOG=/var/log/vagrant/repo.log

# -- install apps --
for i in ${APPS[@]}; do
  if yum list installed $i
  then
    echo "$i already installed" 1>$LOG
  else
    sudo yum install $i -y 2>>$LOG
  fi
done

# --start Apache --

sudo systemctl start httpd
sudo systemctl enable httpd
sudo mkdir -p /var/www/html/localrepo

sudo sed -i 's/Options Indexes FollowSymLinks/Options All Indexes FollowSymLinks/' /etc/httpd/conf/httpd.conf
sudo rm -rf /etc/httpd/conf.d/welcome.conf
sudo systemctl restart httpd

# -- create Repository --
$YUM_REPO_DIR=""
sudo cd /var/www/html/localrepo

sudo wget https://www.nano-editor.org/dist/v2.2/RPMS/nano-2.2.6-1.x86_64.rpm -P /var/www/html/localrepo
sudo wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"  "http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-linux-x64.tar.gz" -P /var/www/html/localrepo
sudo wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm -P /var/www/html/localrepo

sudo createrepo /var/www/html/localrepo
