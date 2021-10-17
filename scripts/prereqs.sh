#!/usr/bin/env bash
set +x
apt-get update 
apt-get install -y curl xz-utils git sudo

adduser --disabled-password --gecos '' builder 
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers 
adduser builder sudo 
chown -R builder:builder /home/builder/.*