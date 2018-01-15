#!/bin/bash

url=$(curl -s https://api.github.com/repos/oldNoakes/ansible-role-testing-framework/releases/latest | grep "browser_download_url")
echo $url