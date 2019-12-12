#!/bin/bash 

#set -x

name=$1
check_present () {

if [[ -n "$name" ]]; then
	du -sh /home/$name
fi
}

check_present
