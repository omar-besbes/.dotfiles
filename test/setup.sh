#!/bin/bash

# Init
declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare DOCKERFILE_PATH="$DIR/Dockerfile"

# Build docker image
docker build -t dotfiles-test -f $DOCKERFILE_PATH .

# Run docker 
docker run -it \
	--cap-add SYS_ADMIN \
	--device /dev/fuse:/dev/fuse \
	--security-opt apparmor:unconfined \
	dotfiles-test

