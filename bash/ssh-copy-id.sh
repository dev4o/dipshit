#!/bin/bash
for ip in `cat /root/scripts/servers.txt`; do
    ssh-copy-id -i ~/.ssh/id_rsa.pub $ip
done

