#! /usr/bin/env bash

if [ -z $1 ]; then
	echo "This script requires a domain name as an argument.";
	exit 1000;
fi

if [ $UID != "0" ]; then
	echo "You must be root to run this script";
	exit 1001;
if 

HTTP_GROUP="www-data" # centos=nobody,ubuntu/debian=www-data,arch=http
BASE_APP_PATH="/srv";
DOMAIN=$1;

echo "Creating space for ${DOMAIN} ...";
DOMAIN_PATH="${BASE_APP_PATH}/${DOMAIN}";
sudo mkdir -p ${DOMAIN_PATH};
sudo mkdir -p ${DOMAIN_PATH}/public;
sudo mkdir -p ${DOMAIN_PATH}/logs;
sudo chgrp ${HTTP_GROUP} ${DOMAIN_PATH};
sudo chmod 2775 ${BASE_APP_PATH}/${DOMAIN};