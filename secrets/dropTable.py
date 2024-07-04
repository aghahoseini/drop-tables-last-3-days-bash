### author: mohammad mahdi shafiei @ matin international group
### created at: Oct 08 2023 18:30 GMT+3
### last modified: Oct 09 2023 10:08 GMT+3
### desc: it will keep last 3 days(include today) tables and drop other tables based on "aX_logs_%y%m%d pattern


import pymysql  # as usual ;)
import time

# Database connection info
db_host = '127.0.0.1'
db_port = 27312
db_user = 'USERNAME'
db_password = 'PASSWORD'
db_name = 'DBNAME'

# Connect to the desirable database
conn = pymysql.connect(host=db_host, user=db_user, password=db_password, database=db_name, port=db_port)
cursor = conn.cursor()

# Get the current date minus three days - latest policy was keeping last 3 day and drop others
cursor.execute('SELECT CURDATE() - INTERVAL 3 DAY;')
result = cursor.fetchone()
three_days_ago = result[0]

# Generate table name patterns for three days ago - for simplicity and clean coding
table_name_patterns = ['a2_logs_%y%m%d', 'a3_logs_%y%m%d' , 'a4_logs_%y%m%d' , 'a5_logs_%y%m%d']

# Generate the SQL query to drop older tables
drop_table_query = f"SHOW TABLES WHERE Tables_in_maindb LIKE 'a2_logs_%' OR Tables_in_maindb LIKE 'a3_logs_%' OR Tables_in_maindb LIKE 'a4_logs_%' OR Tables_in_maindb LIKE 'a5_logs_%';"

# Execute the SQL query to retrieve table names
cursor.execute(drop_table_query)
tables = cursor.fetchall()

# Generate the SQL queries to drop tables older than three days
drop_table_queries = []
for table in tables:
    table_name = table[0]
    for pattern in table_name_patterns:
        if time.strptime(table_name[len(pattern)-6:], '%y%m%d') < time.strptime(three_days_ago.strftime('%y%m%d'), '%y%m%d'):
            drop_table_queries.append(f"DROP TABLE IF EXISTS {table_name};")
            break

# Execute the SQL queries to drop older tables
for query in drop_table_queries:
    cursor.execute(query)

# Commit the changes
conn.commit()

# Close the cursor and connection
cursor.close()
conn.close()
