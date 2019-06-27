#!/bin/bash -x

WORKDIR=/root/MYSQL_BACKUP
BACKUP_SERVER=backup-server.com
BACKUP_DIR=/storage/backup/daily.0
LOG=/tmp/import_dbs_last_backup.log

echo >> $LOG

if [ ! -d $WORKDIR ];then
mkdir $WORKDIR
fi

cd $WORKDIR

for server in db_1 db_2 db_test server_1;do
        rsync -av --progress root@$BACKUP_SERVER:$(ssh root@$BACKUP_SERVER "ls -1tr $BACKUP_DIR/$server/home/mysql_backup/dbs/DB_NAME*|tail -1") .
done

for db in DB_NAME_1  DB_NAME_2 DB_NAME_3 DB_NAME_4;do

        if [ $db = 'DB_NAME_1' ];then
                echo "Importing $db ... $(date)" >> $LOG
                /usr/bin/mysql -uroot -pDBPASSWORD -e "drop database $db; create database $db;"
                zcat $(ls -1rt | grep "DB_NAME-[^_1][0-9]*" | tail -1) | mysql -u root -p'DBPASSWORD' $db
                echo "update user set validate_password = 0;" | mysql -u root -p'DBPASSWORD' $db
        elif [ $db = 'DB_NAME_2' ];then
                echo "Importing $db ... $(date)" >> $LOG
                /usr/bin/mysql -uroot -pDBPASSWORD -e "drop database $db; create database $db;"
                zcat $(ls -1rt | grep "DB_NAME_2*" | tail -1) | mysql -u root -p'DBPASSWORD' $db
                echo "update user set validate_password = 0;" | mysql -u root -p'DBPASSWORD' $db
        elif [ $db = 'DB_NAME_3' ];then
        echo "Importing $db ... $(date)" >> $LOG
                /usr/bin/mysql -uroot -pDBPASSWORD -e "drop database $db; create database $db;"
                zcat $(ls -1rt | grep "DB_NAME_3*" | tail -1) | mysql -u root -p'DBPASSWORD' $db
                echo "update user set validate_password = 0;" | mysql -u root -p'DBPASSWORD' $db
        elif [ $db = 'DB_NAME_4' ];then
                echo "Importing $db ... $(date)" >> $LOG
                /usr/bin/mysql -uroot -pDBPASSWORD -e "drop database $db; create database $db;"
                zcat $(ls -1rt | grep "DB_NAME_4*" | tail -1) | mysql -u root -p'DBPASSWORD' $db
                echo "update user set validate_password = 0;" | mysql -u root -p'DBPASSWORD' $db
        fi
done
echo "update proc set definer='db_name@%' where definer='db_name2@%' ;" | mysql -u root -p'DBPASSWORD' mysql
echo "Finished ... $(date)" >> $LOG

rm -rf *.gz

