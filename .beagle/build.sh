#!/bin/bash 

set -ex

mkdir -p dist

export GOARCH=amd64
make build
mv kube-vip dist/kube-vip-linux-$GOARCH

export GOARCH=arm64
make build
mv kube-vip dist/kube-vip-linux-$GOARCH

export GOARCH=ppc64le
make build
mv kube-vip dist/kube-vip-linux-$GOARCH