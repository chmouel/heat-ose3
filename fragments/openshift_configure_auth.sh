#!/bin/bash
set -ev

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
sleep 5 # WTF!
