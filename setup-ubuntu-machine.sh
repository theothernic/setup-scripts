#! /usr/bin/env bash

sudo apt-get install git; 

curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -;
sudo add-apt-repository ppa:nginx/stable;
sudo apt-get update;

sudo apt-get install -y nodejs;
sudo sudo apt-get --yes install nginx;

sudo apt-get install mariadb-server;

sudo apt-get install redis-server;