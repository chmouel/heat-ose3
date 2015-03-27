#!/bin/bash
mkdir -p /root/.ssh
chmod 0700 /root/.ssh
ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
ssh-keyscan localhost > ~/.ssh/known_hosts
