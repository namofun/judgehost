#!/bin/bash

if [[ $EUID -ne 0 ]]
then
    echo "Root permission is required"
    exit
fi

apt update
apt upgrade -y

# basis for the judgehost program
apt install -y \
    make sudo debootstrap autoconf automake \
    unzip libcgroup-dev lsof procps \
    php-cli php-curl php-json php-xml php-zip \
    libcurl4-gnutls-dev libjsoncpp-dev libmagic-dev

# C/C++
apt install -y gcc g++

# Java
apt install -y openjdk-11-jre-headless openjdk-11-jdk

# Haskell
apt install -y ghc

# Pascal
apt install -y fp-compiler

# Python 2/3
apt install -y python3 python2.7
