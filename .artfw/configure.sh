#!/bin/bash

ROLE_ROOT=$(cd $(dirname $0)/.. && pwd) # cd to directory of this script

function git_ignore() {
    touch $ROLE_ROOT/.gitignore
    ignoreme=$1
    grep "${ignoreme}" $ROLE_ROOT/.gitignore 2>&1 >/dev/null
    if [ $? -ne 0 ]
    then
      echo "${ignoreme}" >> $ROLE_ROOT/.gitignore
    fi
}

for path in '.artfw/downloads/*' tests/docker/docker.rc tests/docker/docker.env tests/venv tests/test.yml.sample 'tests/roles/*' '!tests/roles/spec';
do
  git_ignore "${path}"
done