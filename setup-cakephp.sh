#! /usr/bin/env bash

CAKEPHP_DOWNLOAD_VERSION="2.4.9";
CAKEPHP_DOWNLOAD_URL="https://github.com/cakephp/cakephp/archive/$CAKEPHP_DOWNLOAD_VERSION.tar.gz";

wget $CAKEPHP_DOWNLOAD_URL;

#if [[ ! -d "cakephp" ]] ; then
#	mkdir cakephp;
#fi

tar zxf $CAKEPHP_DOWNLOAD_VERSION.tar.gz;

sudo cp -R cakephp-$CAKEPHP_DOWNLOAD_VERSION/lib/Cake /usr/local/lib/Cake;

rm -f $CAKEPHP_DOWNLOAD_VERSION.tar.gz;
rm -rf cakephp-$CAKEPHP_DOWNLOAD_VERSION;
