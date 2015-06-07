#!/bin/bash

cd /third/go/src
export GOROOT=/third/go
export GOPATH=/lounge/go
export PATH=$PATH:$GOROOT/bin
mkdir -p /lounge/go

./all.bash
go get -u github.com/ipfs/go-ipfs/cmd/ipfs

mkdir -p /ipfs/
mkdir -p /ipns/
chown root:users /ipfs/ /ipns/
chmod g+rwx /ipfs/ /ipns/

