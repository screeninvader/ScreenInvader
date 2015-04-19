#!/bin/bash

INFO="`kpartx -av "$1"`"
PART1="`echo "$INFO" | sed 2d | cut -d" " -f3`"
PART2="`echo "$INFO" | sed 1d | cut -d" " -f3`"

mkdir -p "$2/p1"
mkdir -p "$2/p2"
umount "$2/p1"
umount "$2/p2"

sleep 3
mount /dev/mapper/$PART1 "$2/p1"
mount /dev/mapper/$PART2 "$2/p2"

