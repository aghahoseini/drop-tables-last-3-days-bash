# backup


mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e 'use bash; show tables'

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "SELECT CURDATE() - INTERVAL 7 DAY;"

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e 'CREATE DATABASE IF NOT EXISTS bash;CREATE TABLE IF NOT EXISTS bash.a1_logs_240617  (id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,fname VARCHAR(30) NOT NULL , lname VARCHAR(30) NOT NULL)';
mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e 'INSERT INTO  bash.a1_logs_240617 ( fname,lname ) VALUES ("mmd" , "last name"),("hosein","last name");'


mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e 'DROP TABLE IF EXISTS bash.a1_logs_240617;'
mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e 'use bash; select * from  a1_logs_240617'

mysql -u root -P 3307 -pabcd6789  -h 127.0.0.1 -e "SELECT CURDATE() - INTERVAL 7 DAY;"
