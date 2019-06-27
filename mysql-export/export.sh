#!/bin/bash

WORKDIR=/tmp

/usr/bin/python3 $WORKDIR/jira-export-v2.py
sleep 10
cd $WORKDIR
tar -zcvf "jiradb-output$(date '+_%Y%m%d').tar.gz" "jiradb-output$(date '+_%Y%m%d').csv"
echo "Please find attached the Jira comments daily export" | mail -s "JiraDB Daily Query Output" -a $WORKDIR/jiradb-output$(date '+_%Y%m%d').tar.gz -c test@mail.com -c test2@mail.com
