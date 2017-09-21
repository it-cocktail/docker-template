#!/bin/bash

sed -i "s/ForceCommand internal-sftp/ForceCommand internal-sftp -u 0002/" /etc/ssh/sshd_config

