#!/bin/bash

# Script parameters.
LINODE_TOKEN=$1
SCRIPT_ID=$2
SCRIPT_FILE=$3

# Source helper scripts.
source /tools/linode_helpers.sh

# Execute linode-cli command.
exec_linode_cli ${LINODE_TOKEN} stackscripts update ${SCRIPT_ID} \
    --script /ss/${SCRIPT_FILE}
