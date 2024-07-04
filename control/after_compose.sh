#!/bin/bash

#######################################################################################################################################################
### author: hosein aghahoseini @ matin international group
### created at: June 26 2024 09:32  GMT+3
### last modified: June 26 2024 09:32  GMT+3
### description: it will restore backups
#######################################################################################################################################################


db_host='127.0.0.1'
db_port=3307
db_user='root'
db_password='abcd6789'
db_name='bash'
backup_save_path='/home/backups'

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; show tables"





mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a2_logs_20240629 "

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a2_logs_20240630 "

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a2_logs_20240701"

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a2_logs_20240702"

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a2_logs_20240703 "




mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a3_logs_20240629 "

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a3_logs_20240630 "

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a3_logs_20240701"

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a3_logs_20240702"

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a3_logs_20240703 "



mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a4_logs_20240629 "

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a4_logs_20240630 "

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a4_logs_20240701"

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a4_logs_20240702"

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a4_logs_20240703 "



mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a5_logs_20240629 "

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a5_logs_20240630 "

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a5_logs_20240701"

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a5_logs_20240702"

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; select * from  a5_logs_20240703 "




three_days_ago=`mysql -u $db_user -P $db_port -p$db_password -h $db_host -e "SELECT CURDATE() - INTERVAL 3 DAY;" | sed -n '2p'` 

echo "  "

echo "***tables before this date:$three_days_ago first backuped(dumped and gzipped) and saved in $backup_save_path and then removed***";



