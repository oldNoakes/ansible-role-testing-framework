SHELL  := /bin/bash
RED    := \033[0;31m
GREEN  := \033[0;32m
CYAN   := \033[0;36m
YELLOW := \033[1;33m
NC     := \033[0m # No Color

DOCKERIMG := oldnoakes/infratest-centos
makefile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
container_name := $(notdir $(patsubst %/,%,$(dir $(makefile_path))))
running_docker := $(shell docker ps -q -f name=${container_name})

usage:
	@printf "${YELLOW}make test                 ${GREEN}# Test using docker. ${NC}\n"
	@printf "${YELLOW}make debug                ${GREEN}# Test using docker and returns to bash on the container. ${NC}\n"
	@printf "${YELLOW}make vagrant_up           ${GREEN}# Test using vagrant up. ${NC}\n"
	@printf "${YELLOW}make vagrant_provision    ${GREEN}# Test using vagrant provision. ${NC}\n"
	@printf "${YELLOW}make vagrant_destroy      ${GREEN}# Destroy the vagrant box. ${NC}\n"

verify:
	@which virtualenv >/dev/null || (printf "${RED}Please install virtualenv${NC}\n" && exit 1)
	@which pip >/dev/null || (printf "${RED}Please install pip${NC}\n" && exit 1)

docker_verify:
	@which docker >/dev/null || (printf "${RED}Please install docker${NC}\n" && exit 1)

vagrant_verify:
	@which vagrant >/dev/null || (printf "${RED}Please install vagrant${NC}\n" && exit 1)

clean:
	@find . -name '*.retry' -exec rm -f {} +

docker_clean: clean verify docker_verify
ifneq ($(running_docker),)
	@printf "Killing the running docker container: ${container_name}\n"
	@docker kill ${container_name}
endif
	@rm -rf /var/tmp/docker_ssh && mkdir -p /var/tmp/docker_ssh
	@rm -f docker_return_code

configure:
	@./tests/setup_ansible.sh

docker_env:
	@./tests/docker/setup_docker_env.sh

docker_sshkey: docker_run
	@ssh-keygen -b 2048 -t rsa -f /var/tmp/docker_ssh/id_rsa -q -N ""
	@docker cp /var/tmp/docker_ssh/id_rsa.pub ${container_name}:/home/vagrant/.ssh/authorized_keys
	@docker exec ${container_name} /bin/bash -c 'chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys'

docker_run: docker_env
	docker pull ${DOCKERIMG}:latest
	docker run -P --name ${container_name} -d --cap-add=SYS_ADMIN --cap-add=NET_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro --rm --hostname ${container_name} -e "container=docker" --env-file ./tests/docker/docker.env ${DOCKERIMG}:latest

test: docker_clean configure docker_env docker_sshkey
	source tests/venv/bin/activate && ./tests/docker/ansible.sh; echo $$? > docker_return_code
	@docker kill ${container_name}
	@exit $$(cat docker_return_code)

debug: docker_clean configure docker_env docker_sshkey
	source tests/venv/bin/activate && ./tests/docker/ansible.sh; docker exec -it ${container_name} /bin/bash

vagrant_up: clean verify vagrant_verify configure
	source tests/venv/bin/activate && vagrant up

vagrant_provision: clean verify vagrant_verify configure
	source tests/venv/bin/activate && vagrant provision

vagrant_destroy: vagrant_verify
	vagrant destroy -f

.PHONY: test
