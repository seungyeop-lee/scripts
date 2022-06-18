INSTANCE_NAME := "ssh"

.PHONY: install
install:
	./install.sh

.PHONY: reset
reset:
	./reset.sh

IP := $(shell multipass info $(INSTANCE_NAME) | grep IPv4: | cut -d ':' -f2 | tr -ds ' ' '')
.PHONY: ssh
ssh:
	ssh -i .ssh/id_rsa root@$(IP)