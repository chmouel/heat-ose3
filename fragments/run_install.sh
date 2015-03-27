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

yum -y install httpd-tools
touch /etc/openshift-passwd
htpasswd -b /etc/openshift-passwd joe redhat
htpasswd -b /etc/openshift-passwd alice redhat
cat <<EOF >> /etc/sysconfig/openshift-master
OPENSHIFT_OAUTH_REQUEST_HANDLERS=session,basicauth
OPENSHIFT_OAUTH_HANDLER=login
OPENSHIFT_OAUTH_PASSWORD_AUTH=htpasswd
OPENSHIFT_OAUTH_HTPASSWD_FILE=/etc/openshift-passwd
OPENSHIFT_OAUTH_ACCESS_TOKEN_MAX_AGE_SECONDS=172800
EOF
systemctl restart openshift-master

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
