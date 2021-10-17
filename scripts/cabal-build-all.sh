#!/usr/bin/env bash
set +x
# executes cabal build all
# parses executables created from compiler output and copies it to ~./cabal/bin folder.

# executes cabal build all
# parses executables created from compiler output and copies it to ~./cabal/bin folder.
source /tekton/home/.ghcup/env

export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

git clone https://github.com/input-output-hk/cardano-node.git && cd cardano-node
git fetch --all --recurse-submodules --tags
git checkout tags/$VERSION

cabal configure --with-compiler=ghc-8.10.4

echo "Running cabal update to ensure you're on latest dependencies.."
echo "Building..."
cabal build $PACKAGES 2>&1 | tee /tmp/build.log

grep "^Linking" /tmp/build.log | grep -Ev 'test|golden|demo' | while read -r line ; do
    act_bin_path=$(echo "$line" | awk '{print $2}')
    act_bin=$(echo "$act_bin_path" | awk -F "/" '{print $NF}')
    echo "Copying $act_bin to ./src/bin/"
    mkdir -p ./src/bin/
    cp -f "$act_bin_path" "./src/bin/"
done