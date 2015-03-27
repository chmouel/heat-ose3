#!/bin/bash

yum -y remove NetworkManager*
yum -y install wget vim-enhanced net-tools bind-utils tmux git

yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
yum --enablerepo=epel -y install ansible
