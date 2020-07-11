#!/bin/bash
yum update -y
sudo yum install -y httpd24 php56 mysql55-server php56-mysqlnd 
sudo service httpd start 
sudo chkconfig httpd on 
sudo usermod -a -G apache ec2-user 
sudo chown -R ec2-user:apache /var/www 
sudo chmod 2775 /var/www 
find /var/www -type d -exec sudo chmod 2775 {} \; 
find /var/www -type f -exec sudo chmod 0664 {} \; 
echo "<h1>hi here </h1>" > /var/www/html/index.html
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
