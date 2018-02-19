#!/bin/bash

###### GET INSTALLATION URLs ######
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
TC_URL="https://download.jetbrains.com/teamcity/TeamCity-2017.2.2.tar.gz"

# Directory there maven, tomcat, and application installed
HOME_DIR=/home/vagrant

###############################
###### JAVA INSTALLATION ######
###############################

# -- Check if Java is already installed
JAVA_CHECK=$(java -version 2>&1)
if [[ "$JAVA_CHECK" == "java version \"1.8.0"* ]]; then
  echo "Java is successfully installed!" 1>>$LOG
else
  # -- Java installation --
  wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "$JDK_URL" 2>$LOG

  # --Add Veriables and Edit app.sh file --
  JDK_LOCATION=/usr/local/java/jdk1.8.0_161 # знаходити автоматом
  export JAVA_HOME=$JDK_LOCATION
  export JRE_HOME=$JDK_LOCATION/jre
  export PATH=$PATH:$JDK_LOCATION/bin:$JDK_LOCATION/jre/bin

  VAR_FILE=/etc/profile.d/app.sh
  cat >> $VAR_FILE <<EOF
export JAVA_HOME=$JDK_LOCATION
export JRE_HOME=$JDK_LOCATION/jre
export PATH=$PATH:$JDK_LOCATION/bin:$JDK_LOCATION/jre/bin
EOF

  # -- install java --
  sudo rpm -ihv --prefix=/usr/local/java  ${JDK_URL##*/} 2>>$LOG # треба видалити архів
  #sudo rm -r  2>>$LOG

  # -- Check JAVA Instalation --
  if [[ "$JAVA_CHECK" == "java version \"1.8.0"* ]]; then
    echo "Java is successfully installed!" 1>>$LOG
  else
    echo "Java installation failed!" 1>>$LOG
  fi
fi

###############################
###### MAVEN INSTALATION ######
###############################

# -- Check if Maven is installed
MVN_CHECK=`mvn -v`
if [[ "$MVN_CHECK" == *"Apache Maven 3.5"* ]]; then
  echo "Maven is successfully installed!" 1>>$LOG
else
  MVN=${MVN_URL##*/}
  cd $HOME_DIR
  wget "$MVN_URL" -P $HOME_DIR/
  tar xzvf $MVN 2>>$LOG # треба видалити архів

  # -- Edit Veriables app.sh file --
  export MAVEN_HOME=$HOME_DIR/${MVN%-bin.tar.gz}
  export PATH=$PATH:$HOME_DIR/${MVN%-bin.tar.gz}/bin
  cat >> $VAR_FILE <<EOF
    export MAVEN_HOME=$HOME_DIR/${MVN%-bin.tar.gz}
    export PATH=$PATH:$HOME_DIR/${MVN%-bin.tar.gz}/bin
EOF
  if [[ "$MVN_CHECK" == *"Apache Maven 3.5"* ]]; then
    echo "Maven is successfully installed!" 1>>$LOG
    # rm -f $MVN
  else
    echo "Maven installation failed!" 1>>$LOG
  fi
fi

#######################
###### TEAM CITY ######
#######################

#TODO Додати перевірку встановлення томкату
TC_CHECK=`echo $CATALINA_HOME`
if [[ "$TC_CHECK" == *"TeamCity"* ]]; then
  echo "TeamCity is successfully installed!" 1>>$LOG
else
  TC=${TC_URL##*/}
  cd $HOME_DIR
  wget "$TC_URL" -P $HOME_DIR/

  tar xzvf $TC 2>>$LOG # треба видалити архів
  #export CATALINA_HOME=$HOME_DIR/${TOM%.tar.gz}
  # -- Edit app.sh file --
  #cat >> $VAR_FILE <<EOF
#export CATALINA_HOME=$HOME_DIR/${TOM%.tar.gz}
#EOF
# -- open ports for tomcat
sudo iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 8111 -j ACCEPT
sudo sed -i 's/IPTABLES_SAVE_ON_STOP=\"no\"/IPTABLES_SAVE_ON_STOP=\"yes\"/g' /etc/sysconfig/iptables-config
sudo sed -i 's/IPTABLES_SAVE_ON_RESTART=\"no\"/IPTABLES_SAVE_ON_STOP=\"yes\"/g' /etc/sysconfig/iptables-config
fi

################################
###### BUILD APPLICATION #######
################################

#TODO -- get application ---
cd $HOME_DIR
git clone https://github.com/IF-066-Java/bugTrckr.git

APP_CONF=/home/vagrant/bugTrckr/src/main/resources/application.properties
sed -i 's/jdbc.username=root/jdbc.username=ivan/' $APP_CONF 2>>$LOG
sed -i 's/jdbc.password=root/jdbc.password=1a_ZaraZa@/' $APP_CONF 2>>$LOG # bed idea
sed -i 's/localhost/192.168.56.101/' $APP_CONF 2>>$LOG

DB_CONF=/home/vagrant/bugTrckr/src/main/resources/sql_maven_plugin.properties
sed -i 's/drop-database=true/drop-database=false/' $DB_CONF 2>>$LOG
sed -i 's/create-database=true/create-database==false/' $DB_CONF 2>>$LOG
sed -i 's/create-tables=true/create-tables==false/' $DB_CONF 2>>$LOG
sed -i 's/fill-in-the-tables=true/fill-in-the-tables=false/' $DB_CONF 2>>$LOG
sed -i 's/localhost/192.168.56.101/' $DB_CONF 2>>$LOG

#TODO -- create warfile --
#cd $HOME_DIR/bugTrckr
#mvn clean package

#cp $HOME_DIR/bugTrckr/target/*.war $HOME_DIR/${TOM%.tar.gz}/webapps
#cp /vagrant/tom*.xml $HOME_DIR/${TOM%.tar.gz}/conf

# -- run tomcat
#$CATALINA_HOME/bin/startup.sh
