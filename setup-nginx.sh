#! /usr/bin/env bash

sudo apt-get -y install python-software-properties;
sudo apt-get -y install software-properties-common;
sudo add-apt-repository ppa:nginx/stable;
sudo apt-get update;
sudo apt-get -y install nginx;

