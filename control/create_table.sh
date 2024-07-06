#!/bin/bash


db_name="maindb"
today=`mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e  "SELECT CURDATE()" | sed -n '2p'` 
today=`date -d $today +'%y%m%d'`
sql_file='../mysql_scripts/a.sql';



#date -d "$b 2 day ago" +'%y%m%d'

echo " " > ../mysql_scripts/a.sql

#date -d "$b 1 day ago" +'%y%m%d'
echo "CREATE DATABASE IF NOT EXISTS $db_name; "  >> $sql_file
echo "  " >> ac.sql



    for i in {2..5}
    do

        for x in {1..5}
        do 


            ctime=`date -d "$today $x day ago" +'%y%m%d'`

            #echo "$i"
            echo "CREATE TABLE IF NOT EXISTS  $db_name.a${i}_logs_${ctime}  (id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,fname VARCHAR(30) NOT NULL , lname VARCHAR(30) NOT NULL);" >> $sql_file
            echo "INSERT INTO  $db_name.a${i}_logs_${ctime}  ( fname,lname ) VALUES ('"a${i}  ${ctime}"' , '"last name"'),('"a${i}  ${ctime}"','"last name"');"  >> $sql_file


        done 

        echo "  " >> $sql_file

    done

