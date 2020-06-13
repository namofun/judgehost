#!/bin/bash

if [[ $EUID -ne 0 ]]
then
    echo "Root permission is required"
    exit
fi

read -p "Input the count of judgehosts: " cnt
for ((i=0;i<cnt;i++));
do
    useradd -d /nonexistent -U -M -s /bin/false domjudge-run-$i
    systemctl enable domjudge-judgehost@$i
    echo "Judgehost $i setup..."
done
