#!/bin/bash
# TODO(chmou): This is all not very pretty and not very nice,
set -ex
source /etc/sysconfig/heat-params

git clone https://github.com/detiber/openshift-ansible.git -b \
    ${ANSIBLE_BRANCH} /root/openshift-ansible

cp -af /root/openshift-ansible/inventory/byo/group_vars  /etc/ansible
sed -i '/^openshift_hostname_workaround/ { s/false/true/ }' /etc/ansible/group_vars/all

cat <<EOF >/etc/ansible/hosts
[masters]
localhost

[nodes]
localhost
EOF

ansible-playbook -v /root/openshift-ansible/playbooks/byo/config.yml
