#!/bin/bash
set -x
if [ $# -ne 2 ]; then
  echo "Usage: makeall.sh <version> <arch>"
fi
rm -r screeninvader-*
./makekernel.sh $1 $2
./makeconfig.sh $1 $2
./makecore.sh $1 $2
./makemisc.sh $1 $2
./makearch.sh $1 $2


