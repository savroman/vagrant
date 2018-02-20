#!/bin/bash

###### MySQL INSTALLATION ######

# -- version of MySQL to use --
MYSQL="mysql57-community-release-el7-11.noarch.rpm"

# -- create error log file --
LOG=/var/log/vagrant/mysql.log

# check if MySQL is installed
MYSQL_CHECK=`mysql --version`
if [[ "$MYSQL_CHECK" == "mysql"*"Distrib 5.7."* ]]; then
  echo "MySQL is installed!" 1>$LOG
  UP=$(pgrep mysql | wc -l);
  if [ "$UP" -ne 1 ]; then
    echo "MySQL is down." 1>>$LOG
    sudo systemctl start mysqld.service 2>>$LOG
  else
    echo "All is well." 1>>$LOG
  fi
else
  sudo yum localinstall -y https://dev.mysql.com/get/$MYSQL 2>>$LOG
  sudo yum install -y mysql-community-server 2>>$LOG
  sudo rm -r $MYSQL 2>>$LOG
  sudo systemctl start mysqld.service 2>>$LOG
  sudo systemctl status mysqld.service 2>>$LOG
  sudo systemctl enable mysqld 2>>$LOG

  #get mysql root pass from mysqld.log and
  TP=$(grep 'temporary password' /var/log/mysqld.log|cut -d ":" -f 4|cut -d ' ' -f 2) 2>>$LOG
  #writing mysql root pass into file
  sudo echo $TP>/opt/tp.txt 2>>$LOG
  #TODO dodaty normalnu zaminu paroliv
  mysql -uroot -p$(echo $TP) -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '1qaz@WSX';" --connect-expired-password
  sudo echo "bind-address=0.0.0.0">>/etc/my.cnf 2>>$LOG
fi
#TODO dodaty normalnu zaminu paroliv
UPASS=1a_ZaraZa@
mysql -uroot -p$(echo "1qaz@WSX") -e "CREATE DATABASE sonar DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;" 2>>$LOG
mysql -uroot -p$(echo "1qaz@WSX") -e "GRANT ALL ON *.* TO 'ivan'@'%' IDENTIFIED BY '$UPASS';" 2>>$LOG
mysql -uroot -p$(echo "1qaz@WSX") -e "GRANT ALL ON sonar.* TO 'sonarqube'@'%' IDENTIFIED BY 'J0benB0ben';" 2>>$LOG


# -- open ports for aplications
sudo iptables -A INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
sudo sed -i 's/IPTABLES_SAVE_ON_STOP=\"no\"/IPTABLES_SAVE_ON_STOP=\"yes\"/g' /etc/sysconfig/iptables-config
sudo sed -i 's/IPTABLES_SAVE_ON_RESTART=\"no\"/IPTABLES_SAVE_ON_STOP=\"yes\"/g' /etc/sysconfig/iptables-config
#https://www.howtoforge.com/tutorial/how-to-install-mysql-57-on-linux-centos-and-ubuntu/

#$(echo $(cat /opt/tp.txt))
