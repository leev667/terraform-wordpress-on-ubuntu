#!/bin/bash

#Package updates and Installs

sudo apt update -y
sudo apt upgrade -y
sudo apt install apache2 -y
sudo apt install mysql-server -y
sudo apt install php libapache2-mod-php php-mysql -y
sudo systemctl reload apache2

#Database set up
set -e
source /home/rocky/terraform-wordpress-on-ubuntu/.env-vars.sh
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'DB_Password';"
sudo -i 
cat << EOF | tee /root/.my.cnf
[client]
user=root
password=D@rkL0rdS1th
EOF
mysql -e "GRANT ALL PRIVILEGES ON *.* TO root@localhost WITH GRANT OPTION;"
mysql -e "CREATE DATABASE wordpress;"
mysql -e "CREATE USER 'wordpressusr'@'localhost' IDENTIFIED BY 'WP_DB_Password';"
mysql -e "GRANT ALL ON wordpress.* TO 'wordpressusr'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

#Make web dir
mkdir -p /var/www/vhosts/the-flea.co.uk


#Install Wordpress
wget -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
tar -xzvf /tmp/wordpress.tar.gz -C /tmp
rsync -r /tmp/wordpress/ /var/www/vhosts/the-flea.co.uk
chown -R www-data:www-data /var/www/vhosts/the-flea.co.uk
find /var/www/vhosts/the-flea.co.uk -type d -exec chmod 2775 {} \;
find /var/www/vhosts/the-flea.co.uk -type f -exec chmod 644 {} \;

#Configure Virtual Host
cat << EOF | tee /etc/apache2/sites-available/the-flea.co.uk.conf
<VirtualHost *:80>
  ServerName your_domain_or_ip
  DocumentRoot /var/www/vhosts/the-flea.co.uk
  <Directory /var/www/vhosts/>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>
</VirtualHost>
EOF

a2ensite the-flea.co.uk.conf
a2dissite 000-default.conf
systemctl reload apache2

#Configure DB bind address
#sed -i.bak 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
#systemctl restart mysql

apt install php8.3-fpm -y
a2enmod proxy_fcgi setenvif
a2enconf php8.3-fpm
systemctl restart apache2
cat << EOF | tee /var/www/vhosts/the-flea.co.uk/info.php
<?php
phpinfo();
?>
EOF
