#! /usr/bin/env bash

curl -L get.rvm.io | sudo bash -s stable;

sudo apt-get install -y libruby1.9 zlib1g-dev libssl-dev 
    libreadline-dev build-essential libghc6-zlib-dev;

rvm requirements;