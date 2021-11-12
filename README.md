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

* Kubernetes cluster on version 1.20+

* Helm 3

For local:

* Docker engine

## Running locally with docker

```bash
git clone https://github.com/jrx-sjg/cardano-helm.git

mkdir db/

docker pull ghcr.io/jrx-sjg/cardano-helm:$VERSION-$BUILD_ID
docker run -ti -e NETWORK=mainnet -v $PWD/docker/node/config/:/opt/cardano/files -v $PWD/db/:/opt/cardano/db ghcr.io/jrx-sjg/cardano-helm:$VERSION-$BUILD_ID
```

## Install the chart

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

    helm repo add <<myrepo>> https://jrx-sjg.github.io/cardano-helm/

you can search the charts via:

    helm install cardano-helm <<myrepo>>/cardano-helm --namespace <<mynamespace>> --values <<myvalues.yaml>>

### View the YAML

You can have a look at the underlying charts YAML at: [index.yaml](index.yaml)