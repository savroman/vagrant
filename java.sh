#!/bin/bash
#sudo yum install wget -y

# -- create log file --
LOG=/var/log/vagrant/java.log

# -- Insert JDK URL --
# 1. Visit http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html?printOnly=1
# 2. Accept the Oracle Binary Code License Agreement for Java SE
# 3. Put link of your version "jdk-8u161*.rpm" to JDK_URL
JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.rpm"

# -- Insert Maven URL --
# 1. Visit https://maven.apache.org/download.cgi
# 2. Put link of your version "apache-maven-3*.tar.gz" to MVN_URL
MVN_URL="http://apache.ip-connect.vn.ua/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz"

# -- Insert Tomcat URL --
# 1. Visit https://tomcat.apache.org/download-70.cgi
# 2. Put link of your version "apache-maven-3*.tar.gz" to MVN_URL
TOM_URL="http://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.84/bin/apache-tomcat-7.0.84.tar.gz"

###### JAVA INSTALLATION ######
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "$JDK_URL" 2>$LOG

# -- Edit app.sh file --
JDK_LOCATION=/usr/local/java/jdk1.8.0_161 # знаходити автоматом
VAR_FILE=/etc/profile.d/app.sh
export JAVA_HOME=$JDK_LOCATION
export JRE_HOME=$JDK_LOCATION/jre
export PATH=$PATH:$JDK_LOCATION/bin:$JDK_LOCATION/jre/bin

cat >> $VAR_FILE <<EOF
export JAVA_HOME=$JDK_LOCATION
export JRE_HOME=$JDK_LOCATION/jre
export PATH=$PATH:$JDK_LOCATION/bin:$JDK_LOCATION/jre/bin
EOF
#

# -- install java --
sudo rpm -ihv --prefix=/usr/local/java  ${JDK_URL##*/} 2>>$LOG # треба видалити архів

# -- Check JAVA Instalation --
JAVA_CHECK=`java -version`
if [[ "$JAVA_CHECK" == *"Java(TM) SE Runtime Environment"* ]]; then
   echo "Java is successfully installed!" 2>>$LOG
else
   echo "Java installation failed!" 2>>$LOG
fi

###### MAVEN INSTALATION ######
MVN=${MVN_URL##*/}
MVN_LOCATION=/usr/local/
cd $MVN_LOCATION
wget "$MVN_URL"


tar xzvf $MVN 2>>$LOG # треба видалити архів
export MAVEN_HOME=$MVN_LOCATION${MVN%-bin.tar.gz}
export PATH=$PATH:$MVN_LOCATION${MVN%-bin.tar.gz}/bin

# -- Edit app.sh file --
cat >> $VAR_FILE <<EOF
export MAVEN_HOME=$MVN_LOCATION${MVN%-bin.tar.gz}
export PATH=$PATH:$MVN_LOCATION${MVN%-bin.tar.gz}/bin
EOF

MVN_CHECK=`mvn -v`
if [[ "$MVN_CHECK" == *"Apache Maven"* ]]; then
   echo "Maven is successfully installed!" 2>>$LOG
else
   echo "MAven installation failed!" 2>>$LOG
fi

###### TOMCAT INSTALATION ######
TOM=${TOM_URL##*/}
TOM_LOCATION=/usr/local/
cd $TOM_LOCATION
wget "$TOM_URL"


tar xzvf $TOM 2>>$LOG # треба видалити архів
export CATALINA_HOME=$TOM_LOCATION${TOM%.tar.gz}
# -- Edit app.sh file --
cat >> $VAR_FILE <<EOF
export CATALINA_HOME=$TOM_LOCATION${TOM%.tar.gz}
EOF

# Додати перевірку встановлення томкату
