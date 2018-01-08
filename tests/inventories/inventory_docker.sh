#!/bin/bash
DOCKER_HOST=127.0.0.1
DOCKER_PORT=`docker port ANSIBLE_ROLE_CHANGE_THIS 22 | awk -F: '{ print $2 }'`

echo "{\"all\":{\"hosts\":[\"${DOCKER_HOST}\"],\"vars\":{\"ansible_ssh_port\":\"${DOCKER_PORT}\"}}}"
