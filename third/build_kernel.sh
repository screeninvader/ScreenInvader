#!/bin/bash

cd linux-sunxi
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- sun7i_defconfig
make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage modules


