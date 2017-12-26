SHELL  := /bin/bash
RED    := \033[0;31m
GREEN  := \033[0;32m
CYAN   := \033[0;36m
YELLOW := \033[1;33m
NC     := \033[0m # No Color

DOCKERIMG := oldnoakes/infratest-centos
makefile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
role_name := $(notdir $(patsubst %/,%,$(dir $(makefile_path))))
running_docker := $(shell docker ps -q -f name=${role_name})

usage:
	@printf "${YELLOW}make test                 ${GREEN}# Test using docker. ${NC}\n"
	@printf "${YELLOW}make debug                ${GREEN}# Test using docker and returns to bash on the container. ${NC}\n"

verify:
	@which virtualenv >/dev/null || (printf "${RED}Please install virtualenv${NC}\n" && exit 1)
	@which docker >/dev/null || (printf "${RED}Please install docker${NC}\n" && exit 1)
	@which pip >/dev/null || (printf "${RED}Please install pip${NC}\n" && exit 1)

clean:
	@find . -name '*.retry' -exec rm -f {} +

docker_clean: clean verify
ifneq ($(running_docker),)
	@printf "Killing the running docker container: ${role_name}\n"
	@docker kill ${role_name}
endif
	@rm -rf /var/tmp/docker_ssh && mkdir -p /var/tmp/docker_ssh
	@rm -f docker_return_code

configure:
	@./tests/setup_ansible.sh

docker_env:
	@./tests/docker/setup_docker_env.sh

docker_sshkey: docker_run
	@ssh-keygen -b 2048 -t rsa -f /var/tmp/docker_ssh/id_rsa -q -N ""
	@docker cp /var/tmp/docker_ssh/id_rsa.pub ${role_name}:/home/vagrant/.ssh/authorized_keys
	@docker exec ${role_name} /bin/bash -c 'chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys'

docker_run: docker_env
	docker pull ${DOCKERIMG}:latest
	docker run -P --name ${role_name} -d --cap-add=SYS_ADMIN --cap-add=NET_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro --rm --hostname ${role_name} -e "container=docker" --env-file ./tests/docker/docker.env ${DOCKERIMG}:latest

test: docker_clean configure docker_env docker_sshkey
	source tests/venv/bin/activate && ./tests/docker/ansible_local.sh; echo $$? > docker_return_code
	@docker kill ${role_name}
	@exit $$(cat docker_return_code)

debug: docker_clean configure docker_env docker_sshkey
	source tests/venv/bin/activate && ./tests/docker/ansible_local.sh; docker exec -it ${role_name} /bin/bash

.PHONY: test
