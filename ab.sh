#!/bin/bash


#######################################################################################################################################################
### author: mohammad mahdi shafiei @ matin international group
### created at: Oct 08 2023 18:30 GMT+3
### last modified: Oct 09 2023 12:27 GMT+3
### description: it will keep last 7 days(include today) tables and archive other tables based on "a1_logs_%y%m%d" pattern and save them under /home/backups
#######################################################################################################################################################


#Tables whose creation date is before $three_days_ago 
#They will be backed up first (with mysqldump method)
#and then compress that backup file ( with gzip method )
#and this file saved in $backup_save_path
#Then that table are deleted from database



log_file=./logfiles/log.$(date +%F%T).txt
touch $log_file
exec >> $log_file 2>&1

echo "-------$(date +%Y-%m-%d-%H:%M:%S)------" 
echo " "



#this script contain commands that need to root priviledge to exuecute properly .
echo "check script executed with root priviledge or not  ... "

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

#output of below command without pipe ---> 
# line1: CURDATE() - INTERVAL 3 DAY 
# line2:2024-06-18
today=`mysql -u $db_user -P $db_port -p$db_password -h $db_host -e "SELECT CURDATE() " | sed -n '2p'` 



#calculate 3 days ago time
#output of above command after pipe ---> 2024-06-18
three_days_ago=`mysql -u $db_user -P $db_port -p$db_password -h $db_host -e "SELECT CURDATE() - INTERVAL 3 DAY;" | sed -n '2p'` 

echo "today      : $today"
echo "3_days_ago : $three_days_ago"


echo "Creating the folder where the backups are going to be kept on that . mean $backup_save_path"
echo "check folder creation is successful or not .... "
mkdir -p $backup_save_path

if [ $? -eq 0 ]; then
	echo “folder created successfully”
else
    echo “cant create folder ” 
fi

echo "  "




echo "fetching the names of all tables that 
Their name is a pattern similar to a1_logs_% and save this table names in a array named all_table_names"
#We will need this array in the future
#We will iterate over this array 
#and We will filter members of this array whose value  a date that is older than 3 days ago
#now table_names is array
all_table_names=(`mysql -u $db_user -P $db_port -p$db_password -h $db_host -e "USE bash;SHOW TABLES LIKE 'a1_logs_%';" | grep a1 | grep -v bash`)

if [ $? -eq 0 ]; then
	echo “table names fetched successfully”
    echo "  "
    
else
	echo “table name fetchind failed”
    exit 2;
fi


echo "converting value of three_days_ago variable to a pattern like  %Y%m%d"
#convert 2024-06-18 to 20240618
three_days_ago=`date -d $three_days_ago +'%Y%m%d'`

if [ $? -eq 0 ]; then
	echo “formating three_days_ago variable successfuly done”
    echo "  "
    
else
	echo “formating three_days_ago variable successfuly failed”
    exit 2;
fi






#' We will filter members of this array($all_table_names)
#whose members have a value equal to
#a date
#that is older than 3 days ago'
for single_table_name in "${all_table_names[@]}"
do

    #convert a1_logs_20240527 to 20240527
    date_section_in_table_name=`echo $single_table_name | awk -F"_" '{ print $3 }'`


    backup_file_name=$single_table_name".sql.gz"



    if [ $three_days_ago -gt $date_section_in_table_name ]; then



        echo "Taking a backup of a table named $single_table_name and then compress it "

        #mysqldump -P $db_port -h $db_host --user=$db_user --password=$db_password $db_name $single_table_name | gzip -c > $backup_save_path/$backup_file_name;

        if [ $? -eq 0 ]; then
	        echo “The backup and compression process was done successfully”
        else
        	echo “The backup or compression process failed”
            exit 2;
        fi
 
        echo "drop table: $single_table_name (of course . after taking a backup from that)."
        #mysql -u $db_user -P $db_port -p$db_password -h $db_host -e "use $db_name;DROP TABLE IF EXISTS $single_table_name;"

        if [ $? -eq 0 ]; then
	        echo “The drop process was done successfully”
            echo "  "
        else
        	echo “The drop process failed”
            exit 2;
        fi



        
    fi


done

