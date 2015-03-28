=========================================
Heat Template for OpenShift Enterprise v3
=========================================

Introduction
------------

This is a simple heat template to deploy OpenShift Enterprise v3.

It's not very pretty at this time and just deploy on a single VM at the moment
since I can't make openshift-sdn work properly against neutron.

This is heavily inspired by the heat-kubernetes templates so kudos to lars for
all that work that has been done there.

Settings
--------

A few settings needs to be passed, which is mostly have to do with your
RHN. You create a file `local.yaml` with this kind of content::

  parameters:
    rhel_user: rhn_login@email.com
    rhel_password: myrhnpassword
    rhel_pool: pool_id_where_your_ose3_subscription_is_attached
    ssh_key_name: my_ssh_key_name_as_added_to_nova

additionally you can setup other parameters as specified at the top of the
`openshift-ose3.yaml` file

and you can run it like this ::

  heat stack-create -f openshift-ose3.yaml -e local.yaml ose-stack.yaml

which should spawn up the full stack and where you can log into with ssh
`openshift@ip_address`

Usage
-----

When the stack has been created you will be able to log into your master with
the user `openshift` and then using the `osc` command. There is a few demo
templates to play with in the training repository here::

  https://github.com/openshift/training/
