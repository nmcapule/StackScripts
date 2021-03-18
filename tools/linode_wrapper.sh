#!/bin/bash

pushd "${0%/*}" > /dev/null

SCRIPT_NAME=$1
shift

# Source tokens and secrets and envs.
. ../.env

# Run script inside linode-cli image.
docker run \
    -v $(pwd):/tools \
    -v $(pwd)/../ss:/ss \
    --rm -it --entrypoint /bin/bash filefrog/linode \
    /tools/${SCRIPT_NAME} ${LINODE_TOKEN} $@

popd > /dev/null
