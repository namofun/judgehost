#!/bin/bash

if [[ $EUID -ne 0 ]]
then
    echo "Root permission is required"
    exit
fi

apt upgrade
apt update

# basis for the judgehost program
apt install \
    make sudo debootstrap autoconf automake \
    unzip libcgroup-dev lsof procps \
    php-cli php-curl php-json php-xml php-zip \
    libcurl4-gnutls-dev libjsoncpp-dev libmagic-dev

# C/C++
apt install gcc c++

# Java
apt install openjdk-8-jre-headless openjdk-8-jdk

# Haskell
apt install ghc

# Pascal
apt install fp-compiler

# Python 2/3
apt install python3 python2.7

# C#
apt install mono-runtime mono-devel
