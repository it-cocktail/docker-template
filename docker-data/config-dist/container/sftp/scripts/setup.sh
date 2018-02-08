#!/bin/bash

apt update
apt -y install rsync
chmod 600 /etc/ssh/ssh_host_*_key
