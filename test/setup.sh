#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/..")"
declare DOCKERFILE_LOCAL_PATH="$DIR/Dockerfile.local"
declare DOCKERFILE_REMOTE_PATH="$DIR/Dockerfile.remote"

# ----------------------------------------------------------------------
# | Functions                                                          |
# ----------------------------------------------------------------------

show_help() {

	echo ""
	echo "Usage: $0 [--local|--remote]"
	echo ""
	echo "Options:"
	echo "   --local    Execute tests on a machine with locally crafted dotfiles"
	echo "   --remote   Execute tests on a machine with dotfiles fetched remotely"
	echo ""
	exit 1

}

build_docker_image() {

	local -r option=$1
	local -r dockerfile_path=$2
	local -r image_name="dotfiles-test$option"

	docker build -t "$image_name" -f "$dockerfile_path" .

}

create_docker_container() {

	local -r option=$1
	local -r container_name="dotfiles$option"
	local -r image_name="dotfiles-test$option"
	
	# Check if the script is running interactively
	local -r is_interactive=$( [ -t 0 ] && echo '-it' )

	# Create docker container according to the option / interactiveness
	docker run \
		--name "$container_name" \
		--cap-add SYS_ADMIN \
		--device /dev/fuse:/dev/fuse \
		--security-opt apparmor:unconfined \
		"$is_interactive" \
		"$image_name"

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	cd "$ROOT_DIR" || exit 1

	# Check the number of arguments
	if [ "$#" -ne 1 ]; then
	    show_help
	fi

	# Parse the argument
	local option=$1
	case "$option" in
		--local)
			build_docker_image "$option" "$DOCKERFILE_LOCAL_PATH"
			create_docker_container "$option"
			;;
		--remote)
			build_docker_image "$option" "$DOCKERFILE_REMOTE_PATH"
			create_docker_container "$option"
			;;
		*)
			# Invalid argument
			show_help
			;;
	esac

}

main "$@"

