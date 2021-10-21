#!/usr/bin/env bash

trap 'killall -s SIGTERM cardano-node' SIGINT SIGTERM
# "docker run --init" to enable the docker init proxy
# To manually test: docker kill -s SIGTERM container

head -n 36 ~/.scripts/banner.txt

echo "NETWORK: $NETWORK $POOL_NAME $TOPOLOGY";

[[ -z "${CNODE_HOME}" ]] && export CNODE_HOME=/opt/cardano 
[[ -z "${CNODE_PORT}" ]] && export CNODE_PORT=6000

echo "NODE: $HOSTNAME - Port:$CNODE_PORT ;
cardano-node --version;

exec $CNODE_HOME/scripts/cnode.sh