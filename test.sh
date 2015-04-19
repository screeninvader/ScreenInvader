#!/bin/bash
export BOOTSTRAP_LOG="test.log"
echo "" > $BOOTSTRAP_LOG
source .functions.sh

trap 'kill $(jobs -p); kpartx -dv "$image"' EXIT
ssh-keygen -f ~/.ssh/known_hosts -R [localhost]:2222


function sshc() {
	sshpass -p 'lounge' ssh -p 2222 -oStrictHostKeyChecking=no -oConnectTimeout=10 root@localhost "$1" 2>> test.log
	return $?
}

function waitForConnection() {
	seq 0 12 | while read i; do
		sshc id && break || sleep 10
	done
}

export -f waitForConnection sshc
#### main ####

image="$1"

DEVICE="`kpartx -av "$image" | head -n1 | cut -d" " -f8`"
qemu-system-x86_64 -nographic -enable-kvm -hda $DEVICE*2  -net user,hostfwd=tcp::8000-:80,hostfwd=tcp::2222-:22,hostfwd=tcp::9080-:8080 -net nic -m 2048 &


check "Wait for ssh connectivity" \
	'[ "$(waitForConnection)" == "uid=0(root) gid=0(root) groups=0(root)" ] || false'

check "Test Janosh availability" \
	'[ $(sshc "/lounge/bin/janosh hash") == "10577639537861785865" ] || false'

check "Test JanoshAPI availability" \
	"sshc 'bash -lc /third/Janosh/src/JanoshAPI.lua'"
