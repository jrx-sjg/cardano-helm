#!/usr/bin/env bash

GIT_COMMIT_TO_BUILD=${VERSION} # can be a tag/branch
BINARIES_OUTPUT_DIR=${HOME}/.local/bin && mkdir -p ${BINARIES_OUTPUT_DIR}

# Install nix
curl -L https://nixos.org/nix/install > install-nix.sh 
chmod +x install-nix.sh 
./install-nix.sh 
. ${HOME}/.nix-profile/etc/profile.d/nix.sh 

# Clone source repository
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
git checkout ${GIT_COMMIT_TO_BUILD}

# Build using NixOS

nix-build -A scripts.${BUILD_TARGETS} -o node-local
./node-local/bin/cardano-node-mainnet