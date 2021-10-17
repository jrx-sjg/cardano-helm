#!/usr/bin/env bash
set +x
apt-get update -y
apt-get install curl automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool autoconf -y

wget https://downloads.haskell.org/~cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz
tar -xf cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz
rm cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz
mkdir -p $HOME/.local/bin
mv cabal $HOME/.local/bin/

export PATH="~/.local/bin:$PATH"

cabal update && cabal --version

curl -s -m 60 --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sed -e 's#read.*#answer=Y;next_answer=P;hls_answer=N#' | bash

source /root/.ghcup/env
ghcup install ghc 8.10.4
ghcup install cabal 3.4.0.0
ghcup set ghc 8.10.4
ghcup set cabal 3.4.0.0

mkdir -p ~/src

git clone https://github.com/input-output-hk/libsodium && cd libsodium
git checkout 66f017f1
./autogen.sh
./configure && make
make install
