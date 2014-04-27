#! /usr/bin/env bash

sudo apt-get -y install php5-fpm php5-cli php5-mysql;

# These aren't technically PHP FPM related, but they're PHP extensions.
sudo apt-get -y install php5-curl php5-gd php5-mcrypt php-apc php-pear php5-imap php5-xmlrpc php5-sqlite;

cd /etc/php5/cli;
sudo mv php.ini php.ini.backup;
sudo ln -s ../fpm/php.ini;

