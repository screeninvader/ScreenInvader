#!/bin/bash
export BOOTSTRAP_LOG="test.log"
echo "" > $BOOTSTRAP_LOG
source .functions.sh

trap 'kill $(jobs -p)' EXIT
ssh-keygen -f ~/.ssh/known_hosts -R [localhost]:2222

check "sshpass command" \
  "which sshpass"

check "ssh command" \
  "which ssh"


function sshc() {
	sshpass -p 'lounge' ssh -p 2222 -oStrictHostKeyChecking=no -oConnectTimeout=10 root@localhost "$1" 2>> test.log
	return $?
}

export -f sshc
#### main ####

[ $# -ne 3 ] || error "Usage: test.sh [amd64|armhf] <image>"
arch="$1"
image="$2"

./runimage.sh -a "$arch" -n "$image" &>> $BOOTSTRAP_LOG &

check "Wait 60 seconds" \
  "sleep 60"

check "Test ssh connectivity" \
	'sshc id'

sleep 20

check "Test Janosh availability" \
	"sshc '/lounge/bin/janosh hash'"

check "Test JanoshAPI availability" \
	'[ "$(echo "Janosh:tprint({\"hi\"})" | sshc "bash -lc \"/lounge/bin/janosh -f /dev/stdin\"")" == "1: hi" ]'

exit 0
