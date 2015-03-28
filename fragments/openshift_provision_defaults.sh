#!/bin/bash
set -ev

openshift ex new-project demo --display-name="OpenShift 3 Demo" \
--kubeconfig=/var/lib/openshift/openshift.local.certificates/openshift-client/.kubeconfig \
--description="This is the first demo project with OpenShift v3" \
--admin=htpasswd:joe

cd /var/lib/openshift/openshift.local.certificates/openshift-client/
openshift ex router --create \
          --kubeconfig=/var/lib/openshift/openshift.local.certificates/openshift-client/.kubeconfig \
          --credentials=/var/lib/openshift/openshift.local.certificates/openshift-client/.kubeconfig \
          --images='registry.access.redhat.com/openshift3_beta/ose-${component}:${version}'

openshift ex registry --create \
          --kubeconfig=/var/lib/openshift/openshift.local.certificates/openshift-client/.kubeconfig \
          --credentials=/var/lib/openshift/openshift.local.certificates/openshift-client/.kubeconfig \
          --images='registry.access.redhat.com/openshift3_beta/ose-${component}:${version}'

su - openshift -c "mkdir ~/.kube/;cd ~/.kube/;openshift ex login --certificate-authority=/var/lib/openshift/openshift.local.certificates/ca/root.crt --cluster=master --server=https://$(hostname -f):8443 --namespace=demo --username=joe --password=redhat"
