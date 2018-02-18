#!/bin/bash

###### START INSTALLATION ######

# -- add tools --
APPS=(mc net-tools wget git)

# -- create log file --
sudo mkdir /var/log/vagrant
LOG=/var/log/vagrant/start.log

# -- settime time zone --
#ZONE=`grep ZONE /etc/sysconfig/clock`
#if [$ZONE == "*Europe/Kiev*"]
#then
#  echo "Time zone is corect" 1>$LOG
#else
  ping -c 10 8.8.8.8 2>>$LOG
  sudo rm -fr /etc/localtime 2>>$LOG
  sudo ln -s /usr/share/zoneinfo/Europe/Kiev /etc/localtime 2>>$LOG
  sudo yum install -y ntpdate 2>>$LOG
  sudo ntpdate -u pool.ntp.org 2>>$LOG
  echo "Time zone is set to Kiev" 1>>$LOG

# -- add basic tools to VM --
sudo yum update -y 2>>$LOG

# -- install apps --
for i in ${APPS[@]}; do
  if yum list installed $i
  then
    echo "$i already installed" 2>>$LOG
  else
    sudo yum install $i -y 2>>$LOG
  fi
done
