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
	local -r image_name="dotfiles-test--$option"

	local docker_command="
		docker build
			--build-arg CURRENT_BRANCH=$(git branch --show-current)
			-t $image_name
			-f $dockerfile_path
			.
	"

	eval $docker_command
}

create_docker_container() {

	local -r option=$1
	local -r container_name="dotfiles-$option"
	local -r image_name="dotfiles-test--$option"

	# Create docker container according to the option / interactiveness
	local docker_command="
		docker run $([ -t 0 ] && echo '-it')
			--name $container_name
			--cap-add SYS_ADMIN
			--device /dev/fuse:/dev/fuse
			--security-opt apparmor:unconfined
			$image_name
	"

	eval $docker_command

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
	local option="${1//-/}"
	case "$option" in
		local)
			build_docker_image "$option" "$DOCKERFILE_LOCAL_PATH"
			create_docker_container "$option"
			;;
		remote)
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

