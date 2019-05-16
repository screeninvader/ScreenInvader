#!/bin/bash
dir="`dirname $0`"
TEST_DIR="`cd $dir; pwd`"

export BOOTSTRAP_LOG="test.log"
echo "" > $BOOTSTRAP_LOG
source "$TEST_DIR/.functions.sh"

trap 'kill $(jobs -p); kpartx -dv "$image"' EXIT

function printUsage() {
  cat 1>&2 <<EOUSAGE
runimage.sh - Run a disk image inside qemu

Usage: $0 -a <arch> [-n] <target>
<target>     the target location for the disk image

Options:
  -a <arch>        either amd64 or armhf
  -n               run headless
EOUSAGE
  exit 1
}

#### main ####

ARCH=armhf
HEADLESS=

while getopts 'a:n' c
do
  case $c in
    a) ARCH="$OPTARG";;
    n) HEADLESS="YES";;
    \?) printUsage;;
  esac
done

shift $(($OPTIND - 1))

[ $# -ne 1 ] && printUsage
image="$1"

if [ "$ARCH" == "amd64" ]; then
  
  sudo id
  DEVICE="`sudo kpartx -asv "$image" | tail -n1 | cut -d" " -f3`"
  sleep 3
  sudo chmod a+rw "/dev/mapper/`basename $DEVICE`"

  if [ -n "$HEADLESS" ]; then
    qemu-system-x86_64 -m 4G -smp cores=4,threads=1,sockets=1 -vnc :0,websocket=8085 -enable-kvm -drive format=raw,file="/dev/mapper/`basename $DEVICE`" -net user,hostfwd=tcp::8000-:80,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 -net nic -m 2048 || exit 1 
  else
    qemu-system-x86_64 -m 4G -smp cores=4,threads=1,sockets=1 -vga cirrus -sdl -soundhw ac97 -enable-kvm -drive format=raw,file="/dev/mapper/`basename $DEVICE`" -net user,hostfwd=tcp::8000-:80,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 -net nic -m 2048 || exit 1
  fi
elif [ "$ARCH" == "armhf" ]; then
  wget -q -c https://github.com/vfdev-5/qemu-rpi2-vexpress/raw/master/vexpress-v2p-ca15-tc1.dtb
  wget -q -c https://github.com/vfdev-5/qemu-rpi2-vexpress/raw/master/kernel-qemu-4.4.1-vexpress

  if [ -n "$HEADLESS" ]; then
    qemu-system-arm -m 1024 -vnc :0,websocket=8085 -drive format=raw,if=sd,cache=unsafe,file="$image" -M vexpress-a15 -kernel kernel-qemu-4.4.1-vexpress -dtb vexpress-v2p-ca15-tc1.dtb -append root=/dev/mmcblk0p2 -net user,hostfwd=tcp::8000-:80,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 -net nic || exit 1
  else
    qemu-system-arm -m 1024 -drive format=raw,if=sd,cache=unsafe,file="$image"  -M vexpress-a15 -kernel kernel-qemu-4.4.1-vexpress -dtb vexpress-v2p-ca15-tc1.dtb -append root=/dev/mmcblk0p2 -sdl -net user,hostfwd=tcp::8000-:80,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 -net nic || exit 1
  fi
else
  error "Unknown architecture: $ARCH"
fi

exit 0
