#!/bin/bash

###### START INSTALLATION ######

# -- create log file --
sudo mkdir /var/log/vagrant
LOG=/var/log/vagrant/start.log

# -- settime zone --
sudo rm -fr /etc/localtime 2>$LOG
sudo ln -s /usr/share/zoneinfo/Europe/Kiev /etc/localtime 2>>LOG
sudo yum install -y ntpdate 2>>$lOG
sudo ntpdate -u pool.ntp.org 2>>$LOG

# -- add basic tools to VM --
sudo yum update -y 2>>$LOG

# -- add tools --
APPS=(mc net-tools wget git maven)

for i in ${APPS[@]}; do
  if yum list installed $i
  then
    echo "$i already installed" 1>>$LOG
  else
    sudo yum install $i -y 2>>$LOG
  fi
done

exit 0
