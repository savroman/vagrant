#!/bin/bash

sudo cd /etc/yum.repos.d/
for i in $(ls CentOS*.repo); do
    sudo mv $i $i.orig;
done

sudo touch "/etc/yum.repos.d/remove.repo"

cat >> /etc/yum.repos.d/remove.repo <<EOF
[remote]
name=RHEL Apache
baseurl=http://192.168.56.191/localrepo/
enabled=1
gpgcheck=0
EOF
