#!/bin/bash

#######################################################################################################################################################
### author: hosein aghahoseini @ matin international group
### created at: June 26 2024 09:32  GMT+3
### last modified: June 26 2024 09:32  GMT+3
### description: it will keep last 7 days(include today) tables and archive other tables based on "a1_logs_%y%m%d" pattern and save them under /home/backups
#######################################################################################################################################################


db_host='127.0.0.1'
db_port=3307
db_user='root'
db_password='abcd6789'
db_name='bash'

if [[ "$(whoami)" != "root" ]]; then
    echo  "you must be root to run this script . Try again with the sudo"
    exit 2
fi

backup_save_path='/home/backups'

mkdir -p $backup_save_path



#now table_names is array
all_table_names=(`mysql -u $db_user -P $db_port -p$db_password -h $db_host -e "USE bash;SHOW TABLES LIKE 'a1_logs_%';" | grep a1 | grep -v bash`)
#echo ${table_names[@]};


#calculate 7 days ago time
#output of above command without pipe --->  line1: CURDATE() - INTERVAL 7 DAY  line 2:2024-06-18
#output of above command after pipe 2024-06-18
seven_days_ago=`mysql -u $db_user -P $db_port -p$db_password -h $db_host -e "SELECT CURDATE() - INTERVAL 7 DAY;" | sed -n '2p'` 

#convert 2024-06-18 to 20240618
#seven_days_ago=`date -d $seven_days_ago +'%y%m%d'`
seven_days_ago=`date -d $seven_days_ago +'%Y%m%d'`




for single_table_name in "${all_table_names[@]}"
do
    #convert a1_logs_20240527 to 20240527
    date_section_in_table_name=`echo $single_table_name | awk -F"_" '{ print $3 }'`

    backup_file_name=$single_table_name".sql.gz"


    if [ $seven_days_ago  -gt $date_section_in_table_name ]; then

        mysqldump -P $db_port -h $db_host --user=$db_user --password=$db_password $db_name $single_table_name | gzip -c > $backup_save_path/$backup_file_name;
        
        mysql -u $db_user -P $db_port -p$db_password -h $db_host -e "use $db_name;DROP TABLE IF EXISTS $single_table_name;"
    fi

done
