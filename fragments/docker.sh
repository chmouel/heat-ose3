#!/bin/bash
yum -y install docker
sed -i  "s/OPTIONS=.*/OPTIONS='--insecure-registry 0.0.0.0 --selinux-enabled'/" /etc/sysconfig/docker
systemctl start docker
systemctl enable docker

docker pull registry.access.redhat.com/openshift3_beta/ose-haproxy-router:v0.4
docker pull registry.access.redhat.com/openshift3_beta/ose-deployer:v0.4
docker pull registry.access.redhat.com/openshift3_beta/ose-sti-builder:v0.4
docker pull registry.access.redhat.com/openshift3_beta/ose-docker-builder:v0.4
docker pull registry.access.redhat.com/openshift3_beta/ose-pod:v0.4
docker pull registry.access.redhat.com/openshift3_beta/ose-docker-registry:v0.4

docker pull openshift/ruby-20-centos7
docker pull mysql
docker pull openshift/hello-openshift
