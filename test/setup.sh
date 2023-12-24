#!/bin/bash

# Init
declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare DOCKERFILE_PATH="$DIR/Dockerfile"

# Build docker image
docker build -t dotfiles-test -f $DOCKERFILE_PATH .

# Check if the script is running interactively
if [ -t 0 ]; then
	# Run docker interactively
	docker run -it \
		--cap-add SYS_ADMIN \
		--device /dev/fuse:/dev/fuse \
		--security-opt apparmor:unconfined \
		dotfiles-test
else
	# Run docker non-interactively
	docker run \
		--cap-add SYS_ADMIN \
		--device /dev/fuse:/dev/fuse \
		--security-opt apparmor:unconfined \
		dotfiles-test
fi

