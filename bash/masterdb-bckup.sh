#!/bin/bash

# preparation buildbot-master database backup

workdir='/storage/backup'
db='/storage/buildbot/master/state.sqlite'
bckup='/storage/backup/state.sqlite'
log='/storage/backup/masterb.out'

set -x

#
rsync -av $db $workdir
sleep 5

# if bckup exists
if [ -e $bckup ]
  then
  chown -R backup_user:Admins $workdir && gzip $bckup
  sleep 7200
        rm -f $bckup
        echo $(date -u): "File removed successfully..." >> $log
  exit 1
        else
        echo $(date -u): "File not found..." >> $log
fi
