#!/bin/bash

function setup_credentials() {
    LINODE_TOKEN=$1

    mkdir -p /root/.config

    cat <<EOF > /root/.config/linode-cli
[DEFAULT]
default-user = foo

[foo]
token=${LINODE_TOKEN}
EOF
}

function exec_linode_cli() {
    setup_credentials $1
    shift

    linode-cli $@
}
