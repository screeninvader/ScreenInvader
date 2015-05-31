#!/bin/bash

cd /third/go/src
export PATH=$PATH:/third/go/bin/
mkdir -p /lounge/go
export GOROOT=/lounge/go/
export GOPATH=/lounge/go/bin
./all.bash
go get -u github.com/ipfs/go-ipfs/cmd/ipfs

mkdir -p /ipfs/
mkdir -p /ipns/
chown root:users /ipfs/ /ipns/
chmod g+rwx /ipfs/ /ipns/

