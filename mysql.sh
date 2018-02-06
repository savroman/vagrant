#!/bin/bash

###### MySQL INSTALLATION ######

# -- create error log file --
LOG=/var/log/vagrant/mysql.log

MYSQL="mysql57-community-release-el7-11.noarch.rpm"
sudo yum localinstall -y https://dev.mysql.com/get/$MYSQL 2>$LOG
sudo yum install -y mysql-community-server 2>>$LOG
sudo rm -r $MYSQL 2>>$LOG
sudo systemctl start mysqld.service 2>>$LOG
sudo systemctl status mysqld.service 2>>$LOG
sudo systemctl enable mysqld 2>>$LOG

#get mysql root pass from mysqld.log
TP=$(grep 'temporary password' /var/log/mysqld.log|cut -d ":" -f 4|cut -d ' ' -f 2)

#writing mysql root pass into file
sudo echo $TP>/opt/tp.txt

#додати заміну пароля
#https://www.howtoforge.com/tutorial/how-to-install-mysql-57-on-linux-centos-and-ubuntu/
