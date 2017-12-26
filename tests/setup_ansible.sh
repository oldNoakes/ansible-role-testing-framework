#!/bin/bash

cd `dirname $0` # cd to directory of this script
START_DIR="$(pwd)" # Get full path for volume mount

export PATH=${START_DIR}/venv/bin:${PATH}
export PIP_CONFIG_FILE=${START_DIR}/pip.conf

function init_virtualenv() {
  virtualenv --no-site-packages venv && source venv/bin/activate && pip install -r pip-requirements.txt
}

function run_ansible_galaxy() {
  if [ -f ${START_DIR}/requirements.yml ]
  then
    echo "tests/requirements.yml found, running ansible galaxy"
    ansible-galaxy install -r ${START_DIR}/requirements.yml --force -p ${START_DIR}/roles
  fi
}

function symlink_self() {
  ROLE_NAME="$(basename $(dirname "$START_DIR"))"
  mkdir -p ${START_DIR}/roles
  rm -f ${START_DIR}/roles/${ROLE_NAME}
  cd ${START_DIR}
  ln -fs ./../../../${ROLE_NAME} ./roles/${ROLE_NAME}
  cd -
}

echo "*************** Setting up Ansible ****************"
init_virtualenv
run_ansible_galaxy
symlink_self
echo "*************** Ansible and ansible-galaxy setup are completed ****************"
