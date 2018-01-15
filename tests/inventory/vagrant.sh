#!/bin/bash
VAGRANT_HOST=127.0.0.1
VAGRANT_BOXNAME=$(basename $(dirname $(dirname $(dirname $0))))
VAGRANT_PORT=`vagrant ssh-config ${VAGRANT_BOXNAME} | grep Port | tail -n 1 | awk '{ print $2 }'`

echo "{\"all\":{\"hosts\":[\"${VAGRANT_HOST}\"],\"vars\":{\"ansible_ssh_port\":\"${VAGRANT_PORT}\"}}}"
