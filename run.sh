#!/bin/bash

###### RUN APLICATION ######

LOG=/var/log/vagrant/run.log

#cd /tmp
#sudo git clone https://github.com/yurkovskiy/JavaSimpleProj.git 2>$LOG
# sudo chown -R vagrant:vagrant bugTrckr/
# sudo chmod -R 644 bugTrckr/

#APP_CONF=/opt/bugTrckr/src/main/resources/application.properties
#sudo sed -i 's/jdbc.username=root/jdbc.username=ivan/' $APP_CONF
#sudo sed -i 's/jdbc.password=root/jdbc.password=la_ZaraZa@/' $APP_CONF

#DB_CONF=/opt/bugTrckr/src/main/resources/sql_maven_plugin.properties
#sudo sed -i 's/drop-database=true/drop-database=false/' $DB_CONF
#sudo sed -i 's/create-database=true/create-database==false/' $DB_CONF
#sudo sed -i 's/create-tables=true/create-tables==false/' $DB_CONF
#sudo sed -i 's/fill-in-the-tables=true/fill-in-the-tables=false/' $DB_CONF
#
# -- add input rull --
sudo iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
#sudo iptables -A INPUT -p tcp -m tcp --dport 9000 -j ACCEPT

# -- change iptables settings --
sudo sed -i 's/IPTABLES_SAVE_ON_STOP=\"no\"/IPTABLES_SAVE_ON_STOP=\"yes\"/g' /etc/sysconfig/iptables-config
sudo sed -i 's/IPTABLES_SAVE_ON_RESTART=\"no\"/IPTABLES_SAVE_ON_STOP=\"yes\"/g' /etc/sysconfig/iptables-config

# -- run application --
#cd bugTrckr/
#mvn clean package
#http://mirrors.jenkins.io/war-stable/latest/jenkins.war
