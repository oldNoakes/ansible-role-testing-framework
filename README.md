# Ansible Role Testing Framework

Provides both a docker and vagrant setup to test roles against CentOS 7

## Installation 

### First time usage (new or existing role)

To setup the testing framework onto a new or exiting role, run the following:

```
curl -sSL https://raw.githubusercontent.com/oldNoakes/ansible-role-testing-framework/master/install.sh | bash
```

### Update the role once it has been installed

To update the role testing framework to the latest release, run the following:

```
make update_test_framework
```

## Usage

The pattern that has been used for the roles that are currently using the testing framework require the following to be done:

1. Create a test.yml file in the tests/ directory that is a basic playbook that runs the role under test as well as any 'testing requirements' over and above the dependencies listed in your ```meta/main.yml``` file.
2. Create a ```spec``` role in the tests/roles directory - this spec role should be a series of validations to verify that the role is doing what you expect
3. Run a testing target against the Makefile and verify the results

Here are 2 roles that have implemented the role testing framework with travis CI builds as well:

* [ansible-role-maven](https://github.com/oldNoakes/ansible-role-maven) - [CI](https://travis-ci.org/oldNoakes/ansible-role-maven)
* [ansible-role-jetbrains-licensing-server](https://github.com/oldNoakes/ansible-role-jetbrains-licensing-server) - [CI](https://travis-ci.org/oldNoakes/ansible-role-jetbrains-licensing-server)

The available Makefile targets are as follows:

```
make test                       # Test using docker.
make debug                      # Test using docker and returns to bash on the container.
make vagrant_up                 # Test using vagrant up.
make vagrant_provision          # Test using vagrant provision.
make vagrant_destroy            # Destroy the vagrant box.
make update_test_framework      # Update to latest role testing framework release.
```

## Resources

* Centos Linux Docker codebase: https://github.com/oldNoakes/infrastructure-testing-container  