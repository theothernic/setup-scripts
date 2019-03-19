#! /usr/bin/env bash

sudo dd if=/dev/zero of=/swapfile bs=1M count=1024;
sudo mkswap /swapfile;
sudo swapon /swapfile;

#/swapfile swap swap defaults 0 0