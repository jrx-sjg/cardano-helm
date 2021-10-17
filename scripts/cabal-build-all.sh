#!/usr/bin/env bash

adduser --disabled-password --gecos '' builder 
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers 
adduser builder sudo 
chown -R builder:builder /home/builder/.*

su builder

GIT_COMMIT_TO_BUILD=1.30.1 # can be a tag/branch
BINARIES_OUTPUT_DIR=${HOME}/.local/bin && mkdir -p ${BINARIES_OUTPUT_DIR}

# Install nix
curl -L https://nixos.org/nix/install > install-nix.sh 
chmod +x install-nix.sh 
./install-nix.sh 
. ./.nix-profile/etc/profile.d/nix.sh 

# Clone source repository
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
git checkout ${GIT_COMMIT_TO_BUILD}

# Build using NixOS
for target in ${BUILD_TARGETS}
do
  cp -a \
    $(nix-build -A ${target} --option binary-caches https://iohk-nix-cache.s3-eu-central-1.amazonaws.com/)/bin/${target} \
    ${BINARIES_OUTPUT_DIR}/${target}
done