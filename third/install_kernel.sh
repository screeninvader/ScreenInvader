#!/bin/bash

cd /third/linux-sunxi
make ARCH=arm INSTALL_MOD_PATH=/ modules_install
cp arch/arm/boot/uImage /boot/

