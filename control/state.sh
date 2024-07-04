

docker ps 


three_days_ago=`mysql -u $db_user -P $db_port -p$db_password -h $db_host -e "SELECT CURDATE() - INTERVAL 3 DAY;" | sed -n '2p'` 

echo "  "

echo "***tables before this date:$three_days_ago first backuped(dumped and gzipped) and saved in $backup_save_path and then removed***";

ls -la /home/backups