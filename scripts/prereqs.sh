#!/usr/bin/env bash
set +x

# Building by default by a tekton task using docker oficial haskell:8.10.4 image.
# If Building on any other Debian based distro you will need to uncomment the following

apt-get update -y
apt-get install curl automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool autoconf -y --no-install-recommends

git clone https://github.com/input-output-hk/libsodium && cd libsodium
git checkout 66f017f1
./autogen.sh
./configure && make
make install

