#! /usr/bin/env bash


INSTALL_WEB_SERVER=apache;
INSTALL_DB_SERVER=mariadb;

# update the base system.
sudo apt-get update && sudo apt-get upgrade -y;
sudo apt-get install -y build-essential;


# install a web server.
if [ $INSTALL_WEB_SERVER == "apache" ]; then
	sudo apt-get install -y apache2 libapache2-mod-php;
else
	sudo add-apt-repository -y ppa:nginx/stable;
	sudo apt-get update && sudo apt-get install -y nginx;
fi

# install php
sudo apt-get install -y php7.0 php7.0-mysql php7.0-pgsql php7.0-gd php7.0-intl;

# install a database
if [ $INSTALL_DB_SERVER == "maria" ]; then 
	sudo apt-get install -y mariadb-server;
else
	echo "Database engine not supported.";
fi

# install composer (php package manager)
curl -sL https://getcomposer.org/installer && php -f composer-setup.php;

if [ -f composer.phar ]; then
	sudo mv composer.phar /usr/local/bin/composer;
fi

# install node/npm
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -;
sudo apt-get install -y nodejs;


