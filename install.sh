#!/bin/bash
url=$(curl -s https://api.github.com/repos/oldNoakes/ansible-role-testing-framework/releases/latest | grep "browser_download_url" | awk '{print $2}' | sed 's/"//g')
wget -nv $url -O framework.tar.gz
tar -xzvf framework.tar.gz
rm -f framework.tar.gz

chmod a+x .artfw/configure.sh && .artfw/configure.sh