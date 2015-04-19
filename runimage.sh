#!/bin/bash
trap 'kill $(jobs -p); kpartx -dv "$image"' EXIT

image="$1"

DEVICE="`kpartx -av "$image" | head -n1 | cut -d" " -f8`"
qemu-system-x86_64 -nographic -enable-kvm -hda $DEVICE*2  -net user,hostfwd=tcp::8000-:80,hostfwd=tcp::2222-:22,hostfwd=tcp::9080-:8080 -net nic -m 2048 


