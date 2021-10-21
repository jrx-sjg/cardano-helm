FROM debian:11

LABEL org.opencontainers.image.source https://github.com/jrx-sjg/cardano-helm

ENV \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    ENV=/etc/profile \
    USER=builder \
    CNODE_HOME=/opt/cardano/ \
    CARDANO_NODE_SOCKET_PATH=/opt/cardano/sockets/node0.socket

WORKDIR /

RUN apt-get update \
    && apt-get install -y curl xz-utils git sudo libsodium-dev vim procps

# SETUP Builder USER
RUN adduser --disabled-password --gecos '' builder \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && adduser builder sudo \
    && chown -R builder:builder /home/builder/.*

USER builder
WORKDIR /home/builder/

ENV PATH=/home/builder/.cabal/bin:${PATH} 

COPY ./cardano-node/src/bin/* .cabal/bin/

RUN sudo mkdir -p /opt/cardano/scripts \
    && sudo mkdir -p /opt/cardano/archive \
    && sudo mkdir -p /opt/cardano/sockets \
    && sudo mkdir -p /opt/cardano/logs \
    && sudo mkdir -p /opt/cardano/blocklog \
    && sudo mkdir -p /opt/cardano/files 

# ENTRY SCRIPT

COPY ./docker/node/config/ /opt/cardano/files/
COPY ./docker/node/addons/cnode.sh /opt/cardano/scripts/
COPY ./docker/node/addons/banner.txt .scripts/
COPY ./docker/node/addons/entrypoint.sh .

RUN sudo chown -R builder:builder ./ /opt/cardano/* \
    && sudo chmod a+x /opt/cardano/scripts/*.sh ./entrypoint.sh 

ENTRYPOINT ["./entrypoint.sh"]
