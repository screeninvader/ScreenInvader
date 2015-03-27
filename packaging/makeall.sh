#!/bin/bash
set -x
if [ $# -ne 1 ]; then
  echo "Usage: makeall.sh <version>"
fi
rm -r screeninvader-*
./makekernel.sh $1
./makeconfig.sh $1
./makecore.sh $1
./makemisc.sh $1

