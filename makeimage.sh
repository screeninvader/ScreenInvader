#!/bin/bash
#
# ScreenInvader - A shared media experience. Instant and seamless.
#  Copyright (C) 2012 Amir Hassan <amir@viel-zu.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
trap 'rm /dev/mapper/`basename $LOOPBACK_DEVICE`; kpartx -d $LOOPBACK_DEVICE; losetup -d $LOOPBACK_DEVICE' EXIT

dir="`dirname $0`"
MAKEIMAGE_DIR="`cd $dir; pwd`"

export BOOTSTRAP_LOG="makeimage.log"

source "$MAKEIMAGE_DIR/.functions.sh"

function absDir() {
  dir="`dirname $1`"
  absdir="`cd $dir; pwd`"
  echo $absdir
}

function absPath() {
  dir="`dirname $1`"
  base="`basename $1`"
  absdir="`cd $dir; pwd`"
  echo $absdir/$base
}

function printUsage() {
  cat 1>&2 <<EOUSAGE
makeimage.sh - Prepare a disk image for installation of the ScreenInvader system.

Usage: $0 [-z][-c <chrootdir>][-s <sizeInM>] <target>
<target>	   the target location for the disk image

Options:
  -z               write zeroes to the device before creating the partition
  -s <sizeInM>	   overwrite the default (= 500MB) disk image size.
  -x               Install extlinux
  -u               Install u-boot-sunxi
EOUSAGE
  exit 1
}

WRITE_ZEROES=
IMAGE_SIZE=2000
IMAGE_FILE=
CHROOT_DIR=

while getopts 'zxus:' c
do
  case $c in
    z) WRITE_ZEROES="YES";;
    s) IMAGE_SIZE="$OPTARG";;
    x) MAKE_SYSLINUX="YES";;
    u) MAKE_UBOOT="YES";;
    \?) printUsage;;
  esac
done

shift $(($OPTIND - 1))

[ $# -ne 1 ] && printUsage

IMAGE_FILE="`absPath $1`"
LOOPBACK_DEVICE="`losetup -f`"
MAKESTICK_OPTS="-s $IMAGE_SIZE"
[ -n "$WRITE_ZEROES" ] && MAKESTICK_OPTS="$MAKESTICK_OPTS -z"
[ -n "$MAKE_SYSLINUX" ] && MAKESTICK_OPTS="$MAKESTICK_OPTS -x"
[ -n "$MAKE_UBOOT" ] && MAKESTICK_OPTS="$MAKESTICK_OPTS -u"


[ -n "$CHROOT_DIR" ] && check "Mountpoint $CHROOT_DIR is unused" \
  "! mountpoint -q $CHROOT_DIR"

check "Creating disk image file $IMAGE_FILE of size $IMAGE_SIZE MB" \
  "dd if=/dev/zero of=$IMAGE_FILE bs=1M count=1 seek=$[ $IMAGE_SIZE - 1 ] > /dev/null"

check "Setting up disk image file on loopback device $LOOPBACK_DEVICE" \
  "losetup $LOOPBACK_DEVICE $IMAGE_FILE"

check "Symlinking $LOOPBACK_DEVICE into /dev/mapper" \
  "ln -s $LOOPBACK_DEVICE /dev/mapper/`basename $LOOPBACK_DEVICE`"

./makestick.sh $MAKESTICK_OPTS "/dev/mapper/`basename $LOOPBACK_DEVICE`"
err=$?
check "Run makestick.sh $MAKESTICK_OPTS /dev/mapper/`basename $LOOPBACK_DEVICE`" \
          "[ $err -eq 0 ] || false"

check "Sync" \
  "sync"

check "Remove symlink" \
  "rm /dev/mapper/`basename $LOOPBACK_DEVICE`"

check "Detaching partitions" \
  "kpartx -d $LOOPBACK_DEVICE"

check "Detaching disk image file" \
  "losetup -d $LOOPBACK_DEVICE"

exit 0

