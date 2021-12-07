#!/bin/bash

sleep 60
#* update the instance
cd /home/ec2-user
sudo yum update -y
sudo yum install git -y 
sudo yum install -y mysql
sudo yum install -y dos2unix
export MYSQL_HOST=${DB_connection_string}
sudo yum install -y httpd
sudo service httpd start
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cd wordpress
cp wp-config-sample.php wp-config.php
sudo sed -i 's/database_name_here/${DB_name}/gi' wp-config.php
sudo sed -i 's/username_here/${DB_user}/gi' wp-config.php
sudo sed -i 's/password_here/${DB_pass}/gi' wp-config.php
sudo sed -i 's/localhost/${DB_host}/gi' wp-config.php
sed -i '/put your unique phrase here/d' wp-config.php
curl https://api.wordpress.org/secret-key/1.1/salt/ > test
cat test >> wp-config.php
sudo dos2unix wp-config.php
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
cd /home/ec2-user
sudo cp -r wordpress/* /var/www/html/
sudo service httpd restart