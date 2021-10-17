FROM debian

ENV \
DEBIAN_FRONTEND=noninteractive \
LANG=C.UTF-8 \
ENV=/etc/profile \
USER=builder 

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

# Install NIX 
RUN curl -L https://nixos.org/nix/install > install-nix.sh \
    && chmod +x install-nix.sh \
    && ./install-nix.sh 

COPY . .

RUN . ./.nix-profile/etc/profile.d/nix.sh \
    &&  nix-build -A scripts.mainnet.node -o mainnet-node-local \
    && ./mainnet-node-local/bin/cardano-node-mainnet
    