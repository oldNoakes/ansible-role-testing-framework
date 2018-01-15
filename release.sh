#!/bin/bash

mkdir -p releases
tar -cvzf releases/ansible-role-test-framework.tar.gz -T release.files
