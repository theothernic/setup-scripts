#! /usr/bin/env bash


sudo apt-get install -y libruby1.9 zlib1g-dev libssl-dev libreadline-dev build-essential libghc6-zlib-dev libcurl4-openssl-dev;

curl -L get.rvm.io | sudo bash -s stable;

rvm requirements;