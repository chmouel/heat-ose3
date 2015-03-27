#!/bin/bash
set -ev

subscription-manager register --user '$RHEL_USER$' --password '$RHEL_PASSWORD$'
subscription-manager attach --pool $RHEL_POOL$

subscription-manager repos --disable="*"
subscription-manager repos \
--enable="rhel-7-server-rpms" \
--enable="rhel-7-server-extras-rpms" \
--enable="rhel-7-server-optional-rpms" \
--enable="rhel-server-7-ose-beta-rpms"
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-beta
