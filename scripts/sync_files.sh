#!/bin/bash

[ ! -v DOTFILES_ROOT_DIR ]			&& declare -r DOTFILES_ROOT_DIR="$HOME/.dotfiles"
[ ! -v DOTFILES_GITHUB_ORIGIN ]	&& declare -r DOTFILES_GITHUB_ORIGIN="https://github.com/omar-besbes/.dotfiles"

print_info() {
	echo -e "\e[34m$1\e[0m"
}

sync_dotfiles() {

	if ! git rev-parse --is-inside-work-tree &> /dev/null; then
		# ======================================= #
		# case: FIRST TIME INSTALL                #
		# ======================================= #

		print_info "   [ℹ️] No DOTFILES where detected, beginning a remote install ..."

		# if directory contains anything, move it to /backups/.dotfiles except /backups, of course
		[ ! -z $(ls -A "$DOTFILES_ROOT_DIR") ] && \
			mkdir "$DOTFILES_ROOT_DIR/backups/.dotfiles" && \
			find "$DOTFILES_ROOT_DIR" -maxdepth 1 -mindepth 1 -not -name "backups"
			find "$DOTFILES_ROOT_DIR" -maxdepth 1 -mindepth 1 -not -name "backups" -exec mv -t "$ROOT_DIR/backups/.dotfiles" {} +
		
		# clone repository recursively
		git clone -b main "$DOTFILES_GITHUB_ORIGIN" "$DOTFILES_ROOT_DIR" 
		git submodule sync --recursive
		git submodule update --init --recursive
	else
		# ======================================= #
		# case: DOTFILES ALREADY INSTALLED        #
		# ======================================= #

		print_info "   [ℹ️] Updating DOTFILES ..."

		# get updates from remote
		git fetch
		git pull
		git submodule sync --recursive
		git submodule update --init --recursive
	fi

}

