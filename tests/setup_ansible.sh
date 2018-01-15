#!/bin/bash

cd `dirname $0` # cd to directory of this script
START_DIR="$(pwd)" # Get full path for volume mount
ROLE_NAME_FILE="${START_DIR}/.role_name"

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
  ROLE_DIRECTORY="$(basename $(dirname "$START_DIR"))"
  ROLE_NAME="$(cat ${ROLE_NAME_FILE})"
  mkdir -p ${START_DIR}/roles
  rm -f ${START_DIR}/roles/${ROLE_NAME}
  cd ${START_DIR}
  ln -fs ./../../../${ROLE_DIRECTORY} ./roles/${ROLE_NAME}
  cd -
}

function get_role_name() {
  if [ ! -f ${ROLE_NAME_FILE} ]
  then
    CLONE_DIR_NAME="$(basename $(dirname "$START_DIR"))"
    ROLE_NAME="$(echo $CLONE_DIR_NAME | sed 's/ansible-role-//g' )"
    printf "Please provide the name of this role (Default: ${ROLE_NAME}): "
    read ROLE
    ROLE=${ROLE:-$ROLE_NAME}
    printf $ROLE > ${ROLE_NAME_FILE}
  fi
}

echo "*************** Setting up Ansible ****************"
get_role_name
init_virtualenv
run_ansible_galaxy
symlink_self
echo "*************** Ansible and ansible-galaxy setup are completed ****************"
