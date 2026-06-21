#!/bin/bash
#初始化基础环境

sudo tee /etc/apt/sources.list <<'EOF'
deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse
EOF


#1.静态IP配置
#关闭网卡配置自动还原
sudo tee /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg <<EOF
network: {config: disabled}
EOF
#配置静态IP
sudo tee /etc/netplan/50-cloud-init.yaml <EOF
network:
  ethernets:
    ens33:
      dhcp4: no
      addresses:
        - 192.168.255.151/24
      routes:
        - to: default
          via: 192.168.255.2
      nameservers:
        addresses:
          - 114.114.114.114
          - 8.8.8.8
  version: 2
EOF
sudo netplan apply
#2.关闭防火墙和交换内存
# 停止并禁用 ufw 防火墙
sudo systemctl stop ufw && sudo systemctl disable ufw
# 关闭当前 swap 分区
sudo swapoff -a
# 注释掉 /etc/fstab 里所有包含 swap 的行，永久禁用 swap
sudo sed -i 's/.*swap.*/#&/' /etc/fstab

#3.安装常用工具
sudo apt update && sudo apt install -y \
curl \
wget \
git \
vim \
net-tools \
htop \
apt-transport-https \
ca-certificates \
gnupg
