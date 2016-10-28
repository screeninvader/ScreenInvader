#!/bin/bash

cd linux-sunxi
cp screeninvader.config .config
threads="`grep -c ^processor /proc/cpuinfo`"
make -j"$threads" ARCH=arm CROSS_COMPILE=arm-none-eabi- uImage modules


