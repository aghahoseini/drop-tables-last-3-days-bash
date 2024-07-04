#!/bin/bash
#  cd /home/hosein/Desktop/work/backup/control

today=`mysql -u root -P 3307 -pabcd6789 -h 127.0.0.1 -e "SELECT CURDATE() "| sed -n '2p'`

three_days_ago=`mysql -u root -P 3307 -pabcd6789 -h 127.0.0.1 -e "SELECT CURDATE() - INTERVAL 3 DAY;" | sed -n '2p'`

echo "********"

echo "today is : $today ";

echo " Tables that are before date $three_days_ago  will be deleted "


echo "That is, tables with below dates "

date -d "$three_days_ago 1 day ago" +'%F'
date -d "$three_days_ago 2 day ago" +'%F'

