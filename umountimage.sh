#!/bin/bash

umount "$2/p1"
umount "$2/p2"

kpartx -dv "$1"

