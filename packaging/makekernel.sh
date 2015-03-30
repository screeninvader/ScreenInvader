#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: makekernel.sh <version> <arch>"
fi

mkdir -p screeninvader-kernel/DEBIAN
./makecontrol.sh kernel $1 > screeninvader-kernel/DEBIAN/control
rm -fr screeninvader-kernel/boot screeninvader-kernel/lib 
cp -a ../src/boot ../src/lib screeninvader-kernel/
dpkg-deb -b screeninvader-kernel/ screeninvader-kernel-all.deb
dpkg-sig --sign builder screeninvader-kernel-all.deb
