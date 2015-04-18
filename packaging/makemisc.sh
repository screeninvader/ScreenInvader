#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: makemisc.sh <version> <arch>"
fi

mkdir -p screeninvader-misc/DEBIAN
chmod -R 0755 screeninvader-misc
./makecontrol.sh misc $1 > screeninvader-misc/DEBIAN/control
rm -rf screeninvader-misc/usr
cp -a ../src/usr screeninvader-misc/
dpkg-deb -b screeninvader-misc/ screeninvader-misc-all.deb
dpkg-sig --sign builder screeninvader-misc-all.deb
