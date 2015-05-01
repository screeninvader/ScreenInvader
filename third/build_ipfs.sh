#!/bin/bash

cd /third/go/src
./all.bash
export PATH=$PATH:/third/go/bin/
mkdir -p /lounge/go
export GOPATH=/lounge/go/
go get -u github.com/ipfs/go-ipfs/cmd/ipfs

mkdir -p /ipfs/
mkdir -p /ipns/
chown root:users /ipfs/ /ipns/
chmod g+rwx /ipfs/ /ipns/

