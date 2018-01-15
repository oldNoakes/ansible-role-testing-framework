#!/bin/bash

TEST_DIR=$(cd $(dirname $0)/..; pwd)
export ANSIBLE_CONFIG=${TEST_DIR}/ansible.cfg
export ANSIBLE_ROLES_PATH=${TEST_DIR}/roles
ansible-playbook --inventory ${TEST_DIR}/inventory/docker.sh --key-file /var/tmp/docker_ssh/id_rsa ${TEST_DIR}/test.yml