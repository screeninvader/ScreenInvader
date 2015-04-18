#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: makearch.sh <version> <arch>"
fi
set -x
mkdir -p screeninvader-arch/DEBIAN
chmod -R 0755 screeninvader-arch
./makecontrol.sh arch $1 > screeninvader-arch/DEBIAN/control
rm -rf screeninvader-arch/lounge screeninvader-arch/etc
cp -a ../src/$2/lounge screeninvader-arch/
cp -a ../src/$2/etc screeninvader-arch/

dpkg-deb -b screeninvader-arch/ screeninvader-arch-all.deb
dpkg-sig --sign builder screeninvader-arch-all.deb

