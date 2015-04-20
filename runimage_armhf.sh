#!/bin/bash
trap 'kill $(jobs -p);"' EXIT
image="$1"

wget -q -c https://mirrors.romanrm.net/sunxi/qemu/initrd.img-3.2.0-4-vexpress
wget -q -c https://mirrors.romanrm.net/sunxi/qemu/vmlinuz-3.2.0-4-vexpress

qemu-system-arm -M vexpress-a9 -kernel vmlinuz-3.2.0-4-vexpress -initrd initrd.img-3.2.0-4-vexpress -append root=/dev/mmcblk0p2 -drive if=sd,cache=unsafe,file="$image" -sdl -net user,hostfwd=tcp::8000-:80,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 -net nic

exit 0
