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
sed -i 's/judgedaemon -n 0/judgedaemon -n %i/g' /opt/domjudge/lib/systemd/system/domjudge-judgehost@.service
ln -s /opt/domjudge/lib/systemd/system/domjudge-judgehost@.service /lib/systemd/system/
ln -s /opt/domjudge/lib/systemd/system/create-cgroups.service /lib/systemd/system/

# Debootstrap
echo "Choose debootstrap source"
echo "[1] azure.archive.ubuntu.com (suggested on azure VM)"
echo "[2] mirrors.aliyun.com"
echo "[3] mirrors.cloud.aliyuncs.com (suggested on aliyun ECS)"
echo "[4] mirrors.tuna.tsinghua.edu.cn"
echo "[5] cn.archive.ubuntu.com"
echo "[other] us.archive.ubuntu.com"
read -p "Input your choice: " choice
if [[ $choice -eq 1 ]]
then
    sed -i 's,http://us.archive.ubuntu.com./ubuntu/,http://azure.archive.ubuntu.com/ubuntu,g' /opt/domjudge/judgehost/bin/dj_make_chroot
elif [[ $choice -eq 2 ]]
then
    sed -i 's,http://us.archive.ubuntu.com./ubuntu/,http://mirrors.aliyun.com/ubuntu,g' /opt/domjudge/judgehost/bin/dj_make_chroot
elif [[ $choice -eq 3 ]]
then
    sed -i 's,http://us.archive.ubuntu.com./ubuntu/,http://mirrors.cloud.aliyuncs.com/ubuntu,g' /opt/domjudge/judgehost/bin/dj_make_chroot
elif [[ $choice -eq 4 ]]
then
    sed -i 's,http://us.archive.ubuntu.com./ubuntu/,http://mirrors.tuna.tsinghua.edu.cn/ubuntu,g' /opt/domjudge/judgehost/bin/dj_make_chroot
elif [[ $choice -eq 5 ]]
then
    sed -i 's,http://us.archive.ubuntu.com./ubuntu/,http://cn.archive.ubuntu.com/ubuntu,g' /opt/domjudge/judgehost/bin/dj_make_chroot
fi

/opt/domjudge/judgehost/bin/dj_make_chroot

# Prepare grub file
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet/GRUB_CMDLINE_LINUX_DEFAULT="quiet cgroup_enable=memory swapaccount=1/g' /etc/default/grub

if cat /etc/default/grub | grep "cgroup" > /dev/null
then
    update-grub
    echo "Updated /etc/default/grub. If you have other grub.d files, please update them and add 'cgroup_enable=memory swapaccount=1' to them."
    echo "Please reboot the computer."
else
    echo "Grub file is not set. Please set up 'cgroup_enable=memory swapaccount=1' in /etc/default/grub manually."
    echo "After fixing the grub file, please reboot the computer."
fi
