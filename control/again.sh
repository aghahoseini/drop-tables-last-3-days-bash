docker ps 

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "use bash; show tables"

ls -la /home/backups

sudo rm -rf /home/backups/


docker compose -f /home/hosein/Desktop/work/backup/docker-compose.yml down

docker ps 




docker compose -f /home/hosein/Desktop/work/backup/docker-compose.yml up -d

docker ps 

