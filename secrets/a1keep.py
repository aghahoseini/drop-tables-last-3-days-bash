#######################################################################################################################################################
### author: mohammad mahdi shafiei @ matin international group
### created at: Oct 08 2023 18:30 GMT+3
### last modified: Oct 09 2023 12:27 GMT+3
### description: it will keep last 7 days(include today) tables and archive other tables based on "a1_logs_%y%m%d" pattern and save them under /home/backups
#######################################################################################################################################################

import pymysql
import time
import subprocess
import os

# Database connection details
db_host = '127.0.0.1'
db_port = 27300
db_user = 'USERNAME'
db_password = 'PASSWORD'
db_name = 'DBNAME'

# Connect to the database
conn = pymysql.connect(host=db_host, user=db_user, password=db_password, database=db_name, port=db_port)
cursor = conn.cursor()

# Directory path for archiving backup files
archive_dir = '/home/backups/'

# Get the current date minus seven days - any changes on interval can be change only by CTO confirm
cursor.execute('SELECT CURDATE() - INTERVAL 7 DAY;')
result = cursor.fetchone()
seven_days_ago = result[0]

# Generate the table name pattern for seven days ago by special pattern defined by mrs Aghaie
table_name_pattern = 'a1_logs_%y%m%d'

# Generate the SQL query to drop older tables, just show tables then we'll drop specific tables
drop_table_query = f"SHOW TABLES LIKE 'a1_logs_%';"

# Execute the SQL query to retrieve table names
cursor.execute(drop_table_query)
tables = cursor.fetchall()

# Generate the SQL queries to drop tables older than seven days
drop_table_queries = []
archive_table_names = []
for table in tables:
    table_name = table[0]
    if time.strptime(table_name[len(table_name_pattern) - 6:], '%y%m%d') < time.strptime(seven_days_ago.strftime('%y%m%d'), '%y%m%d'):
        drop_table_queries.append(f"DROP TABLE IF EXISTS {table_name};")
        archive_table_names.append(table_name)

# Archive and compress older tables with tar & gzip
for table_name in archive_table_names:
    # Generate the filename for the archive
    archive_file = table_name + '.sql.gz'

    # Generate the mysqldump command
    mysqldump_cmd = f"mysqldump -uUSERNAME -p'PASSWORD' DBNAME {table_name} | gzip -c > {archive_dir}{archive_file}"

    # Execute the mysqldump command, it was better to get whole process at one command... 
    subprocess.call(mysqldump_cmd, shell=True)

    # Drop the table from the database to free unused space 
    cursor.execute(f"DROP TABLE IF EXISTS {table_name};")

# Commit the changes on connection
conn.commit()

# Close the cursor and connection
cursor.close()
conn.close()
