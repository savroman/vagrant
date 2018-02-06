#!/bin/bash
#Copy paste from Sashko script

###### RUN APLICATION ######

cd /opt
git clone https://github.com/if-078/TaskManagmentWizard-NakedSpring-.git
#reading mysql root pass from file
TP=$(cat /opt/tp.txt)
#creating variable with twm user pass.
TMWPASS=1a_ZaraZa@
#creating twm base and user
mysql -uroot -p$(echo $TP) -e "CREATE DATABASE tmw DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;"
mysql -uroot -p$(echo $TP) -e "GRANT ALL ON tmw.* TO tmw@localhost IDENTIFIED BY '$TMWPASS';"
echo "TMW database and user created"
#change directory to TMW application
cd /opt/T*
cd src/test/resources
#import tmw database
mysql -u tmw -p$TMWPASS tmw <create_db.sql
mysql -u tmw -p$TMWPASS tmw <set_dafault_values.sql
cd /opt/T*
MCONF=src/main/resources/mysql_connection.properties
sed -i 's/jdbc.username=root/jdbc.username=tmw/g' $MCONF
sed -i 's/jdbc.password=root/jdbc.password='$TMWPASS'/g' $MCONF

# -- add input rull --
sudo iptables -I INPUT -p tcp -m tcp --dport 8585 -j ACCEPT

# -- change iptables settings --
sudo sed -i 's/IPTABLES_SAVE_ON_STOP=\"no\"/IPTABLES_SAVE_ON_STOP=\"yes\"/g' /etc/sysconfig/iptables-config
sudo sed -i 's/IPTABLES_SAVE_ON_RESTART=\"no\"/IPTABLES_SAVE_ON_STOP=\"yes\"/g' /etc/sysconfig/iptables-config

# -- run application --
mvn tomcat7:run-war
