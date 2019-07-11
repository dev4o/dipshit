#!/bin/bash

WORKDIR=/home/
cd $WORKDIR
name=$1

  if [[ -n "$name" ]]; then

	grp1="$(getent passwd $1 | grep -o '[0-9]*')"
	grp2="$(echo $grp1 | sed "s/^[^ ]* //")"
	mkdir $1; chown $1:$grp2 $1; chmod 700 $1

  else
  echo "argument error"
fi

