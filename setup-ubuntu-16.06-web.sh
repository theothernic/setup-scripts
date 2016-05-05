#! /usr/bin/env bash


sudo apt-get update && sudo apt-get upgrade;
sudo apt-get install -y build-essential;

sudo apt-get install -y php7.0 php7.0-mysql php7.0-pgsql php7.0-gd php7.0-intl;
sudo apt-get install -y mariadb-server;

sudo add-apt-repository -y ppa:nginx/stable;
sudo apt-get update && sudo apt-get install -y nginx;

curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -;
sudo apt-get install -y nodejs;