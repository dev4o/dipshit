import pymysql
import csv
import sys
import time
#from datetime import datetime


db_opts = {
    'user': 'root',
    'password': 'DBPASS',
    'host': 'localhost',
    'database': 'jiradb'
}

db = pymysql.connect(**db_opts)
cur = db.cursor()

sql = '''select project.pkey, jiraissue.issuenum, jiraaction.author, jiraaction.actionbody, jiraaction.created, entity_property.json_value
       from jiraaction
       inner join entity_property on jiraaction.id=entity_property.entity_id
       inner join jiraissue on jiraaction.issueid=jiraissue.id
       inner join project on project.id=jiraissue.project
where project.pkey = \'IT\' and entity_property.entity_name=\'sd.comment.property\'
'''

timestr = time.strftime("%Y%m%d")

csv_file_path = "/tmp/jiradb-output"
csv_file_path = csv_file_path + '_' + timestr + '.csv'


try:
    cur.execute(sql)
    rows = cur.fetchall()
finally:
    db.close()

# Continue only if there are rows returned.
if rows:
    # New empty list called 'result'. This will be written to a file.
    result = list()

    # The row name is the first entry for each entity in the description tuple.
    column_names = list()
    for i in cur.description:
        column_names.append(i[0])

    result.append(column_names)
    for row in rows:
        result.append(row)

    # Write result to file.
    with open(csv_file_path, 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        for row in result:
            csvwriter.writerow(row)
else:
    sys.exit("No rows found for query: {}".format(sql))
