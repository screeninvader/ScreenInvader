#!/bin/bash

cd linux-sunxi
cp screeninvader.config .config
make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage modules


