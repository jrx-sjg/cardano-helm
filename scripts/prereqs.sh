#!/usr/bin/env bash
set +x
apt-get update 
apt-get install -y curl xz-utils git sudo

adduser --disabled-password --gecos '' builder 
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers 
adduser builder sudo 
chown -R builder:builder /home/builder/.*

mkdir -p /etc/nix
cat <<EOF | sudo tee /etc/nix/nix.conf
substituters = https://cache.nixos.org https://hydra.iohk.io
trusted-public-keys = iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
EOF