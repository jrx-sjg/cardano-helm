# Helm implementation of Cardano Node

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/jrx-sjg/cardano-helm)
![GitHub branch checks state](https://img.shields.io/github/checks-status/jrx-sjg/cardano-helm/main)
[![GitHub issues](https://img.shields.io/github/issues/jrx-sjg/cardano-helm)](https://github.com/jrx-sjg/cardano-helm/issues)
[![GitHub stars](https://img.shields.io/github/stars/jrx-sjg/cardano-helm)](https://github.com/jrx-sjg/cardano-helm/stargazers?style=social)
[![GitHub license](https://img.shields.io/github/license/jrx-sjg/cardano-helm)](https://github.com/jrx-sjg/cardano-helm/blob/main/LICENSE)

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
