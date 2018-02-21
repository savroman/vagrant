#!/bin/bash

#THX to O.Sapeliuk and Co

###################################################
#		Sonarqube   installation  script          #
###################################################
#=================================================#
#				Variables			  			  #
HOST_IP="192.168.56.150"
SONAR_DB="sonar"
SONAR_USR="sonarqube"
SONAR_PASS="J0ben_B0ben"
DB_HOST="db.local"
SONAR_VER="sonarqube-6.7.1"
SONAR_HOME="/opt/sonar"
SONAR_PORT="9000"
SONAR_CONF=$SONAR_HOME/conf/sonar.properties
JAVA_HOME="/opt/jdk"
JRE_HOME="/opt/jdk/jre"
IPT_CONF="/etc/sysconfig/iptables-config"
###################################################
#				BASE SECTION		  	  		  #
###################################################

#base setup
sudo rm -fr /etc/localtime
sudo ln -s /usr/share/zoneinfo/Europe/Kiev /etc/localtime
sudo yum install -y ntpdate
sudo ntpdate -u pool.ntp.org
sudo yum install -y wget

#########################
#JavaSetup section	#
#################################################
#scrip downloads and setup Oracle Java 1.8.0.162#
#################################################
cd /opt/
sudo -s
#downloading and unpaking
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"  "http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-linux-x64.tar.gz"
tar xzf jdk-8u162-linux-x64.tar.gz
#creating version independent directory
ln -s /opt/jdk1.8.0_162 /opt/jdk
alternatives --install /usr/bin/java java $JAVA_HOME/bin/java
alternatives --install /usr/bin/jar jar $JAVA_HOME/bin/jar
alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac
alternatives --set jar $JAVA_HOME/bin/jar
alternatives --set javac $JAVA_HOME/bin/javac
echo "JAVA_HOME=$JAVA_HOME">>/etc/environment
echo "JRE_HOME=$JRE_HOME">>/etc/environment
echo "PATH=$PATH:/opt/jdk/bin:/opt/jdk/jre/bin">>/etc/environment
rm jdk-8u162-linux-x64.tar.gz -f

echo "Java DONE!"

###################################################
#	Sonar   installation  script		  #
###################################################
cd /opt
wget https://sonarsource.bintray.com/Distribution/sonarqube/$SONAR_VER.zip
yum -y install unzip
unzip $SONAR_VER.zip
ln -s /opt/$SONAR_VER $SONAR_HOME
rm -f $SONAR_VER.zip

#we can use this:
#sed -i 's/#sonar.jdbc.username=/sonar.jdbc.username='$SONAR_USR'/g' $SONAR_CONF
#sed -i 's/#sonar.jdbc.password=/sonar.jdbc.password='$SONAR_PASS'/g' $SONAR_CONF
#sed -i 's/#sonar.jdbc.url=jdbc:postgresql:\/\/localhost\/sonar/sonar.jdbc.url=jdbc:postgresql:\/\/'$DB_HOST'\/sonar/g' $SONAR_CONF

echo "
###############################
#added by installation script #
###############################
sonar.jdbc.username=$SONAR_USR
sonar.jdbc.password=$SONAR_PASS
sonar.jdbc.url=jdbc:mysql://$DB_HOST/$SONAR_DB
#Tuning the Web Server for better performance
#sonar.web.javaOpts=-server
#sonar.web.host=$HOST_IP
#sonar.web.port=$SONAR_PORT
#sonar.web.context=/">>$SONAR_CONF

sysctl -w vm.max_map_count=262144
sysctl -w fs.file-max=65536
ulimit -n 65536
ulimit -u 2048
echo "vm.max_map_count = 262144
fs.file-max = 65536">>/etc/sysctl.conf


echo "sonar		soft nofile   	65536
sonar   soft   nproc    2048
sonar soft nofile 65536
sonar hard nofile 65536">>/etc/security/limits.conf
###############################

###############################
#Sonar service script		  #
###############################
sudo ln -s $SONAR_HOME/bin/linux-x86-64/sonar.sh /usr/bin/sonar
#setup sonar as service
cat>/etc/systemd/system/sonar.service<<EOF
echo"
[Unit]
Description=SonarQube service
After=network.target network-online.target
Wants=network-online.target

[Service]
ExecStart=/opt/sonar/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonar/bin/linux-x86-64/sonar.sh stop
ExecReload=/opt/sonar/bin/linux-x86-64/sonar.sh restart
PIDFile=/opt/sonar/bin/linux-x86-64/./SonarQube.pid
Type=forking
User=sonar


[Install]
WantedBy=multi-user.target
EOF

chmod 664 /etc/systemd/system/sonar.service
useradd -r sonar -U
chown -R sonar:sonar $SONAR_HOME
chown -R sonar:sonar $SONAR_VER

sudo chmod 755 /etc/init.d/sonar

#changes that elastisearch want
echo "sonar soft nofile 65536
sonar hard nofile 65536
">>/etc/security/limits.conf

sysctl -w vm.max_map_count=262144
sysctl -w fs.file-max=65536
echo "vm.max_map_count = 262144">>/etc/sysctl.conf
echo "fs.file-max = 65536">>/etc/sysctl.conf


##sudo chkconfig --add sonar
###################################################
#  			HOSTS	  	      #
###################################################
#echo "172.16.0.2	db.local">>/etc/hosts
#echo "172.16.0.3	jenkins.local">>/etc/hosts
#echo "172.16.0.4	sonar.local">>/etc/hosts
#echo "172.16.0.5	bugtrckr.local">>/etc/hosts

sudo echo "192.168.56.150	db.local">>/etc/hosts
sudo echo "192.168.56.170	jenkins.local">>/etc/hosts
sudo echo "192.168.56.180	sonar.local">>/etc/hosts
sudo echo "192.168.56.160	web.local">>/etc/hosts

###################################################
#			allowed iptables rules				  #
###################################################
iptables -I INPUT -p tcp -m tcp --dport $SONAR_PORT -j ACCEPT
#sed -i 's/IPTABLES_SAVE_ON_STOP="no"/IPTABLES_SAVE_ON_STOP="yes"/g' $IPT_CONF
#sed -i 's/IPTABLES_SAVE_ON_RESTART="no"/IPTABLES_SAVE_ON_RESTART="yes"/g' $IPT_CONF
#iptables-save > /etc/sysconfig/iptables
