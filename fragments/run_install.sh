#!/bin/bash
# TODO(chmou): This is all not very pretty and not very nice,

set -ex

mkdir -p /root/.ssh
chmod 0700 /root/.ssh
ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
git clone https://github.com/detiber/openshift-ansible.git -b v3-beta2 /root/openshift-ansible

cp -af /root/openshift-ansible/inventory/byo/group_vars  /etc/ansible
sed -i '/^openshift_hostname_workaround/ { s/false/true/ }' /etc/ansible/group_vars/all

cat <<EOF >/root/.ssh/config
Host *
    ForwardAgent yes
    GSSAPIAuthentication no
    VerifyHostKeyDNS no
    StrictHostKeyChecking no
    HashKnownHosts no
    TCPKeepAlive yes
    ServerAliveInterval 6000
EOF

cat <<EOF >/etc/ansible/hosts
[masters]
localhost

[nodes]
localhost
EOF

ansible-playbook -v /root/openshift-ansible/playbooks/byo/config.yml


openshift ex new-project demo --display-name="OpenShift 3 Demo" \
--description="This is the first demo project with OpenShift v3" \
--admin=htpasswd:joe

openshift ex new-project demo2 --display-name="OpenShift 3 Demo2" \
--description="This is the second demo project with OpenShift v3" \
--admin=htpasswd:joe

openshift ex router --create \
--credentials=/var/lib/openshift/openshift.local.certificates/openshift-client/.kubeconfig \
--images='registry.access.redhat.com/openshift3_beta/ose-${component}:${version}'

openshift ex registry --create \
          --credentials=/var/lib/openshift/openshift.local.certificates/openshift-client/.kubeconfig \
          --images='registry.access.redhat.com/openshift3_beta/ose-${component}:${version}'
