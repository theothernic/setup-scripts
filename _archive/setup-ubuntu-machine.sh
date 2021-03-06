#! /usr/bin/env bash

#sudo apt-get install git; 

# Install build-essential.
sudo apt-get install build-essential;

# Install node apt-get repos. Using the 4.x branch because
# ver 5.x is not stable according to the developers.
curl -sL https://deb.nodesource.com/setup_4.x | sudo bash; 

# Install nginx repos.
sudo add-apt-repository -y ppa:nginx/stable;

# Update apt-get.
sudo apt-get update;

sudo apt-get install -y nodejs;
sudo apt-get install -y nginx;

sudo debconf-set-selections <<< 'mariadb-server mysql-server/root_password s3cr3t';
sudo debconf-set-selections <<< 'mariadb-server mysql-server/root_password_again s3cr3t';
sudo apt-get install -y mariadb-server;

sudo apt-get install redis-server;