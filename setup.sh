#!/bin/bash

which gsed 1>/dev/null || { echo "Please install gsed via homebrew since osx sed sucks"; exit 1; }

DEFAULT_ROLE=$(basename $PWD)
printf "Please provide the role name (Default: ${DEFAULT_ROLE}): "
read ROLE
ROLE=${ROLE:-$DEFAULT_ROLE}
echo "Replacing ANSIBLE_ROLE_CHANGE_THIS with $ROLE in all files"
exit 1
find . -type f ! -name setup.sh -exec gsed -i -e 's/ANSIBLE_ROLE_CHANGE_THIS/'"$ROLE"'/g' {} \;

echo "Cleanup time:"
echo "    Copy the contents of your 'roles' in your tests/test.yml file into both your docker and vagrant test.yml"
echo "    Remove all files in your 'tests' root dir EXCEPT pip-requirements.txt, pip.conf, setup_ansible.sh and requirements.yml"

# update .gitignore
for path in docker_return_code tests/docker/docker.env tests/venv setup.sh test.yml.sample;
do
  grep "${path}" .gitignore
  if [ $? -ne 0 ]
  then
    echo "${path}" >> .gitignore
  fi
done

grep "ansible.cfg" .gitignore
if [ $? -eq 0 ]
then
  sed -i '' '/ansible\.cfg/d' .gitignore
fi
