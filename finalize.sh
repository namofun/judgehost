#!/bin/bash

if [[ $EUID -ne 0 ]]
then
    echo "Root permission is required"
    exit
fi

# Copy previous files
useradd -d /nonexistent -U -M -s /bin/false domjudge-run
cp /opt/domjudge/judgehost/etc/sudoers-domjudge /etc/sudoers.d/
cp /opt/domjudge/lib/systemd/system/domjudge-judgehost.service /opt/domjudge/lib/systemd/system/domjudge-judgehost@.service
ln -s /opt/domjudge/lib/systemd/system/domjudge-judgehost@.service /etc/systemd/system/
ln -s /opt/domjudge/lib/systemd/system/create-cgroups.service /etc/systemd/system/

# Debootstrap
echo "Choose debootstrap source"
echo "[1] azure.archive.ubuntu.com"
echo "[2] mirrors.cloud.aliyuncs.com"
echo "[other] us.archive.ubuntu.com"
read -p "Input your choice: " choice
if [[ $choice -eq 1 ]]
then
    sed -i 's,http://us.archive.ubuntu.com./ubuntu/,http://azure.archive.ubuntu.com/ubuntu,g' /opt/domjudge/judgehost/bin/dj_make_chroot
elif [[ $choice -eq 2 ]]
then
    sed -i 's,http://us.archive.ubuntu.com./ubuntu/,http://mirrors.cloud.aliyuncs.com/ubuntu,g' /opt/domjudge/judgehost/bin/dj_make_chroot
fi

/opt/domjudge/judgehost/bin/dj_make_chroot

# Prepare grub file
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet/GRUB_CMDLINE_LINUX_DEFAULT="quiet cgroup_enable=memory swapaccount=1/g' /etc/default/grub

if cat /etc/default/grub | grep "cgroup" > /dev/null
then
    update-grub
else
    echo "Grub file is not set. Please set up 'cgroup_enable=memory swapaccount=1' in /etc/default/grub manually."
fi

echo "Please reboot the computer."
