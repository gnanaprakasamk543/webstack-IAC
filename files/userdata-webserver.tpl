#!/bin/bash
# Obtain AWS instance metadata
# Set timezone
timedatectl set-timezone UTC

# Install Open JDK
yum install -y ansible
eval "$(ssh-agent -s)"
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
cd /tmp
git clone git@github.com:rgnaveen/ansiblecontrol-apache.git
cd /tmp/ansiblecontrol-apache/plays/apache-installation.yaml
cd /tmp/ansiblecontrol-apache/plays/yumupdate_centos.yaml
cd /tmp/ansiblecontrol-apache/plays/sslcheck.yaml

