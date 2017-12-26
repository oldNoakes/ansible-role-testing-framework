#!/bin/bash

TEST_DIR="$(pwd)/tests"
echo "Running ansible playbook from: ${TEST_DIR}"
ansible-playbook --inventory ${TEST_DIR}/inventories/inventory_docker.sh --key-file /var/tmp/docker_ssh/id_rsa ${TEST_DIR}/test.yml