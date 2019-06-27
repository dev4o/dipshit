#!/bin/bash

set -e

dbs="db1 db2"
local_storage=/backup/mongo
remote_storage=/storage/dump
remote_server=example.prod.com
remote_user=user1

echo "Dumping remote dbs ..."
for db in $dbs
do
    ssh $remote_user@$remote_server "rm -rf $remote_storage/$db; /usr/bin/mongodump --port 30000 -d $db -o $remote_storage/"
    if [ "$db" == "db_2" ];
    then
        ssh $remote_user@$remote_server "rm -rf $remote_storage/db_2_old; mv $remote_storage/db_2 $remote_storage/db_2_old"
    fi
done

dbs="db_3 db_1"
for db in $dbs
do
    echo "Transfering the $db mongodump from $remote_server ..."
    /usr/bin/rsync -av --delete $remote_user@$remote_server:$remote_storage/$db $local_storage/
done

echo "Importing the dbs locally ..."

for db in $dbs
do
    /usr/bin/mongorestore -d $db $local_storage/$db/
done
