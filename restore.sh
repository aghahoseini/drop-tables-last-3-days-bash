
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


log_file_path="/home/${USER}/test"
log_file_name="restore_script_log.$(date +%F%T).txt"

mkdir -p $log_file_path
touch $log_file_path/$log_file_name

LOG_FILE=$log_file_path/$log_file_name


log ()
{
	#echo "$1"
	echo "$1" > $log_file_path/$log_file_name
}

log "-------$(date +%d-%m-%Y-%H%M%S)------" 

where_saved_backup='/home/backups/'

if [[ "$(whoami)" != "root" ]]; then
    log  "you must be root to run this script . Try again with the sudo"
    exit 2
fi



if [[ $1 == "" ]];then


    log 'no option passed - so interactive mode enabled '


fi


while getopts :t OPT; do
    case "$OPT" in

        t)
            log "t option" 

            if [[ $2 == "" ]];then
                log 'option paassed - but value for option not passed . value is date and like 20240217 '
                exit;
            fi

            passed_time_by_user=$2;


            cfilec=(`find /home/backups -name "*$passed_time_by_user*"`);


            if [ -z "${cfilec}" ];then
                log 'for this time backup not found;'
                exit 2;
            fi



            gzip -dk $cfilec;
            mysql -u $db_user -P $db_port -p$db_password -h $db_host $db_name <  ${cfilec::-3}
            rm -rf ${cfilec::-3}


        ;;
        ?)
            log " option invalid ${OPTARG} "
            ;;
    esac
done



