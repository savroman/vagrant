#!/bin/bash
#sudo yum install wget -y

###### JAVA INSTALLATION ######

# -- create log file --
LOG=/var/log/vagrant/java.log

# -- get JDK URL --
# 1. Visit http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html?printOnly=1
# 2. Accept the Oracle Binary Code License Agreement for Java SE
# 3. Put link of your version "jdk-8u161*.rpm" to JDK_URL
JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.rpm"
cd ~/opt
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "$JDK_URL" 2>$LOG

# -- install java --
sudo rpm -ihv --prefix=/usr/local/java  jdk-8u161-linux-x64.rpm 2>>$LOG # треба видалити архів

# -- Edit app.sh file --
JDK_LOCATION=/usr/local/java/jdk1.8.0_161 # знаходити автоматом
VER_FILE=/etc/profile.d/app.sh
cat >> $VER_FILE <<EOF
export JAVA_HOME=$JDK_LOCATION
export JRE_HOME=$JDK_LOCATION/jre
export PATH=$PATH:$JDK_LOCATION/bin:$JDK_LOCATION/jre/bin
EOF

# -- Check JAVA Instalation --
JAVA_CHECK=`java -version`
if [[ "$JAVA_CHECK" == *"Java(TM) SE Runtime Environment"* ]]; then
   echo "Java is successfully installed!" 2>>$LOG
   echo
   java -version
   echo
   exit 0
else
   echo "Java installation failed!" 2>>$LOG
   exit 1
fi
