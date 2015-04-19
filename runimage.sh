#!/bin/bash
trap 'kill $(jobs -p); kpartx -dv "$image"' EXIT
echo start
image="$1"

DEVICE="`kpartx -av "$image" | head -n1 | cut -d" " -f8`"
sleep 3
echo $DEVICE
qemu-system-x86_64 -sdl -soundhw ac97  -enable-kvm -hda "/dev/mapper/`basename $DEVICE`p2" -net user,hostfwd=tcp::8000-:80,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 -net nic -m 2048


