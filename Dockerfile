FROM debian

ENV \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    ENV=/etc/profile \
    USER=builder \
    CNODE_HOME=/opt/cardano/cnode \
    CARDANO_NODE_SOCKET_PATH=$CNODE_HOME/sockets/node0.socket

WORKDIR /

RUN apt-get update \
    && apt-get install -y curl xz-utils git sudo

# SETUP Builder USER
RUN adduser --disabled-password --gecos '' builder \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && adduser builder sudo \
    && chown -R builder:builder /home/builder/.*

USER builder
WORKDIR /home/builder

COPY ./cardano-node/src/bin/* ~/.cabal/bin/

# ENTRY SCRIPT

ADD ./docker/node/addons/banner.txt /home/builder/.scripts/
ADD https://raw.githubusercontent.com/cardano-community/guild-operators/master/files/docker/node/addons/guild-topology.sh /home/builder/.scripts/
ADD https://raw.githubusercontent.com/cardano-community/guild-operators/master/files/docker/node/addons/block_watcher.sh /home/builder/.scripts/
ADD https://raw.githubusercontent.com/cardano-community/guild-operators/master/files/docker/node/addons/healthcheck.sh /home/builder/.scripts/
ADD https://raw.githubusercontent.com/cardano-community/guild-operators/master/files/docker/node/addons/entrypoint.sh ./

RUN sudo mkdir -p /opt/cardano/cnode/ \
    && sudo chown -R builder:builder /opt/cardano/cnode/* \
    && chmod a+x ~/.scripts/*.sh  ~/entrypoint.sh 

HEALTHCHECK --start-period=5m --interval=5m --timeout=100s CMD ~/.scripts/healthcheck.sh