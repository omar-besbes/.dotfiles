#!/bin/bash

# Build docker image
docker build -t dotfiles-test .

# Run docker 
docker run -it \
	--cap-add SYS_ADMIN \
	--device /dev/fuse:/dev/fuse \
	--security-opt apparmor:unconfined \
	dotfiles-test

