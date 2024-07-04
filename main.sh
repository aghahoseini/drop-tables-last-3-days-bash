#!/bin/bash

### author: mohammad mahdi shafiei @ matin international group
### created at: Oct 08 2023 18:30 GMT+3
### last modified: Oct 09 2023 10:08 GMT+3
### desc: it will keep last 3 days(include today) tables and drop other tables based on "aX_logs_%y%m%d pattern





log_file=./logfiles/log.$(date +%F%T).txt
touch $log_file
exec >> $log_file 2>&1

echo "-------$(date +%Y-%m-%d-%H:%M:%S)------" 
echo " "




if [[ "$(whoami)" != "root" ]]; then
    echo  "script executed without root priviledge"
    exit 2
else
    echo "script executed with root priviledge "
    echo "  "
fi





# Database connection details
db_host='127.0.0.1'
db_port=3307
db_user='root'
db_password='abcd6789'
db_name='bash'
backup_save_path='/home/backups'


#calculate today date



#calculate 3 days ago time
#output of above command after pipe ---> 2024-06-18
three_days_ago=`mysql -u $db_user -P $db_port -p$db_password -h $db_host -e "SELECT CURDATE() - INTERVAL 3 DAY;" | sed -n '2p'` 

echo "3_days_ago : $three_days_ago"
echo " Tables that are before date $three_days_ago  will be deleted "



echo "fetching the names of all tables that 
Their name is a pattern similar to aX_logs_%y%m%d (x in range of 2 - 5) and save this table names in a array named all_table_names"
#We will need this array in the future
#We will iterate over this array 
#and We will filter members of this array whose value  a date that is older than 3 days ago
#now table_names is array
all_table_names=(`mysql -u $db_user -P $db_port -p$db_password -h $db_host -e "USE bash;SHOW TABLES WHERE Tables_in_bash LIKE  'a2_logs_%' OR tables_in_bash  LIKE 'a3_logs_%'  OR tables_in_bash  LIKE 'a4_logs_%'  OR tables_in_bash  LIKE 'a5_logs_%' ;" | grep -v bash`)


: " output of above command without pipe
+------------------+
| Tables_in_bash   |
+------------------+
| a2_logs_20240701 |
| a2_logs_20240702 |
| a2_logs_20240703 |
| a5_logs_20240703 |
+------------------+
"

: " output of above command after pipe 

a2_logs_20240701 
a2_logs_20240702 
2_logs_20240703 
a5_logs_20240703 

"


if [ $? -eq 0 ]; then
	echo “table names with pattern like aX_logs_%y%m%d fetched successfully”
    echo "  "
    
else
	echo “table name fetchind failed”
    exit 2;
fi



#converting value of three_days_ago variable to a pattern like  %Y%m%d"
#convert 2024-06-18 to 20240618
three_days_ago=`date -d $three_days_ago +'%Y%m%d'`





#' We will filter members of this array($all_table_names)
#whose members have a value equal to
#a date
#that is older than 3 days ago'
for single_table_name in "${all_table_names[@]}"
do

    #convert aX_logs_20240527 to 20240527
    date_section_in_table_name=`echo $single_table_name | awk -F"_" '{ print $3 }'`



    if [ $three_days_ago -gt $date_section_in_table_name ]; then


        # Execute the SQL queries to drop older tables
        echo "drop table: $single_table_name "
        mysql -u $db_user -P $db_port -p$db_password -h $db_host -e "use $db_name;DROP TABLE IF EXISTS $single_table_name;"

        if [ $? -eq 0 ]; then
	        echo “The drop process was done successfully”
            echo "  "
        else
        	echo “The drop process failed”
            exit 2;
        fi



        
    fi


done

sed -i '/Warning/d' "/home/hosein/Desktop/work/backup/logfiles/${log_file:11}"
#above line removes this lines
#mysql: [Warning] Using a password on the command line interface can be insecure.
