# Helm implementation of Cardano Node

[![Build Status][github-actions-img]][github-actions]
[![GPL-3 licensed][license-img]][license]
[![GitHub release][release-img]][release]
![Github downloads][downloads-img]
Repository for Cardano node deployment using helm.

Custom images built with tekton pipelines and also custom haskell-cabal tekton builder. 

Work in progress. The goal is to implement a fully working API using Helm + Helmfiles and/or ArgoCD

## Requirements

A kubernetes cluster on version 1.20+

Helm 3

For local:

Docker engine

## Running locally with docker

```bash
git clone https://github.com/jrx-sjg/cardano-helm.git

mkdir db/

docker pull ghcr.io/jrx-sjg/cardano-helm:$VERSION-$BUILD_ID
docker run -ti -e NETWORK=mainnet -v $PWD/docker/node/config/:/opt/cardano/files -v $PWD/db/:/opt/cardano/db ghcr.io/jrx-sjg/cardano-helm:$VERSION-$BUILD_ID
```
