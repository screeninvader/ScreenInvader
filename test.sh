#!/bin/bash
export BOOTSTRAP_LOG="test.log"
echo "" > $BOOTSTRAP_LOG
source .functions.sh

trap 'kill $(jobs -p)' EXIT
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

[ $# -ne 3 ] || error "Usage: test.sh [amd64|armhf] <image>"
arch="$1"
image="$2"

if [ "$arch" == "amd64" ]; then
  ./runimage_amd64_headless.sh "$image" &
elif [ "$arch" == "armhf" ]; then
 ./runimage_armhf_headless.sh "$image" &
else
  error "Unknown architecture: $arch" 
fi

check "Wait for ssh connectivity" \
	'[ "$(waitForConnection)" == "uid=0(root) gid=0(root) groups=0(root)" ] || false'

check "Test Janosh availability" \
	'[ $(sshc "/lounge/bin/janosh hash") == "10577639537861785865" ] || false'

check "Test JanoshAPI availability" \
	"sshc 'bash -lc /third/Janosh/src/JanoshAPI.lua'"

exit 0
