#! /usr/bin/env bash

sudo apt-get -y install php5-fpm php5-cli php5-mysql;

cd /etc/php5/cli;
sudo mv php.ini php.ini.backup;
sudo ln -s ../fpm/php.ini;

