#!/bin/bash
localdir=$(cd $(dirname $0); pwd)
roledir=$(cd $localdir/..; pwd)

url=$(curl -s https://api.github.com/repos/oldNoakes/ansible-role-testing-framework/releases/latest | grep "browser_download_url" | awk '{print $2}' | sed 's/"//g')
mkdir -p $localdir/downloads && rm -f $localdir/downloads/framework.tar.gz
wget -nv $url -O $localdir/downloads/framework.tar.gz
tar -xzvf $localdir/downloads/framework.tar.gz -C $roledir

chmod a+x $localdir/configure.sh && $localdir/configure.sh