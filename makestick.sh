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

dir="`dirname $0`"
MAKEPARTITION_DIR="`cd $dir; pwd`"

function printUsage() {
  cat 1>&2 <<EOUSAGE
makestick.sh - Prepare a file system for installation of the ScreenInvader system.

Usage: $0 [-z][-s <sizeInM>] <device-file>

  <device-file>    a block special device.
Options:
  -s <sizeInM>     overwrite the default (= 500MB) file system size.
  -z               write zeroes to the device before creating the partition
  -x               install extlinux
  -u               install uboot-sunxi
EOUSAGE
  exit 1
}

function makeSyslinuxConf() {
  uuid="`blkid $DEVICE*2 | cut -d '"' -f2`"
  templates/syslinux_cfg "$uuid" > "$1/boot/syslinux/syslinux.cfg" 
}

function doCheckPreCond() {
  check "'sfdisk' installed" \
    "which sfdisk"
  check "'mkfs.vfat' installed" \
    "which mkfs.vfat"
  check "'mkfs.ext4' installed" \
    "which mkfs.ext4"
  check "'kpartx' installed" \
    "which kpartx"
  check "'blkid' installed" \
    "which blkid"
  check "'extlinux' installed" \
    "which extlinux"

}

export BOOTSTRAP_LOG="makestick.log"
source "$MAKEPARTITION_DIR/.functions.sh"

WRITE_ZEROES=
SIZE=2000

while getopts 'zxus:' c
do
  case $c in
    z) WRITE_ZEROES="YES";;
    s) SIZE="$OPTARG";;
    x) MAKE_SYSLINUX="YES";;
    u) MAKE_UBOOT="YES";;
    \?) printUsage;;
  esac
done

shift $(($OPTIND - 1))

DEVICE="$1"

[ $# -ne 1 ] && printUsage;
[ ! -b "$DEVICE" ] &&  error "Not a block device: $DEVICE";
[ printf "%d" $SIZE &> /dev/null -o $SIZE -lt 100 ] && error "Invalid size: $SIZE"

doCheckPreCond

if [ -n "$WRITE_ZEROES" ]; then
  check "Write zeros to device" \
    "dd if=/dev/zero of=$DEVICE bs=1M count=$SIZE" 
fi

sfdisk -R $DEVICE
cat <<EOT | sfdisk --in-order -L -uM $DEVICE
1,16,c
,,L
EOT

check "Make partition layout" \
  "[ $? -eq 0 ] || false"

check "Make boot filesystem" \
  "mkfs.vfat $DEVICE*1"

check "Make root filesystem" \
  "mkfs.ext4 $DEVICE*2"

check "Enable writeback mode" \
  "tune2fs -o journal_data_writeback $DEVICE*2"

check "Disable journaling" \
  "tune2fs -O ^has_journal $DEVICE*2"

tmpdir=`mktemp  -d`
check "Make temporary mount dir" \
  "[ $? -eq 0 ]"

check "Mount file system" \
  "mount $DEVICE*2 $tmpdir"

if [ -n "$MAKE_SYSLINUX" ]; then
  check "Prune syslinux dir" \
    "mkdir -p $tmpdir/boot/syslinux/"

  check "Install extlinux" \
    "extlinux --install  $tmpdir/boot/syslinux"

  makeSyslinuxConf "$tmpdir"
  check "Make syslinux.cfg" \
    "[ $? -eq 0 ]"
fi

if [ -n "$MAKE_UBOOT" ]; then
  if [ -d "./u-boot-sunxi" ]; then
    check "Update u-boot-sunxi" \
      "cd u-boot-sunxi; git pull"    
  else
    check "Clone u-boot-sunxi" \
      "git clone https://github.com/screeninvader/u-boot-sunxi.git"
  fi

  check "Make uboot config" \
    "cd u-boot-sunxi; make CROSS_COMPILE=arm-linux-gnueabihf- Bananapi_config"

  check "Build uboot" \
    "cd u-boot-sunxi; make CROSS_COMPILE=arm-linux-gnueabihf-"

  check "Install uboot" \
    "cd u-boot-sunxi; dd if=u-boot-sunxi-with-spl.bin of=$DEVICE bs=1024 seek=8"
fi

check "Umount file system" \
	"umount $DEVICE*2"

check "Remove temporary mount dir" \
  "rmdir $tmpdir"

check "Check boot system" \
  "fsck.vfat -fa $DEVICE*1"

check "Check root system" \
  "fsck.ext4 -fa $DEVICE*2"

exit 0
