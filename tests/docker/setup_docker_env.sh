#!/bin/bash

cd `dirname $0` # cd to directory of this script
ROOT_DIR="$(pwd)"
docker_env_file="${ROOT_DIR}/docker.env"

rm -f $docker_env_file
touch $docker_env_file

if [ ! -z $HTTP_PROXY ] || [ ! -z $http_proxy ]
then
  proxy="${HTTP_PROXY:-$http_proxy}"
  echo "http_proxy=$proxy" >> $docker_env_file
  echo "HTTP_PROXY=$proxy" >> $docker_env_file
fi

if [ ! -z $HTTPS_PROXY ] || [ ! -z $https_proxy ]
then
  ssl_proxy="${HTTPS_PROXY:-$https_proxy}"
  echo "https_proxy=$ssl_proxy" >> $docker_env_file
  echo "HTTPS_PROXY=$ssl_proxy" >> $docker_env_file
fi