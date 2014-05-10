#! /usr/bin/env bash

# Set a root password from an md5 hash.
$TEMP_MYSQL_ROOT_PASS=date|md5;

# install mysql quietly.
export DEBIAN_FRONTEND=noninteractive;
sudo apt-get -y -q install mysql-server-5.5 mysql-client-5.5;

# update root user pass with the generated one from above.
sudo mysqladmin -u root password $TEMP_MYSQL_ROOT_PASSWORD;

# put the temp pass on the filesystem for retrieval.
echo $TEMP_MYSQL_ROOT_PASS > temp_root_password.txt;