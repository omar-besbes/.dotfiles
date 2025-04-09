#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

[ ! -v DOTFILES_GITHUB_ORIGIN ] && declare -r DOTFILES_GITHUB_ORIGIN="https://github.com/omar-besbes/.dotfiles"
[ ! -v DOTFILES_ROOT_DIR_NAME ] && declare -r DOTFILES_ROOT_DIR_NAME=".dotfiles"
[ ! -v DOTFILES_ROOT_DIR ] && declare -r DOTFILES_ROOT_DIR="$HOME/$DOTFILES_ROOT_DIR_NAME"
[ ! -v DOTFILES_SOURCE_DIR_NAME ] && declare -r DOTFILES_SOURCE_DIR_NAME="src"
[ ! -v DOTFILES_SOURCE_DIR ] && declare -r DOTFILES_SOURCE_DIR="$DOTFILES_ROOT_DIR/$DOTFILES_SOURCE_DIR_NAME"
[ ! -v DOTFILES_SCRIPTS_DIR_NAME ] && declare -r DOTFILES_SCRIPTS_DIR_NAME="scripts"
[ ! -v DOTFILES_SCRIPTS_DIR ] && declare -r DOTFILES_SCRIPTS_DIR="$DOTFILES_ROOT_DIR/$DOTFILES_SCRIPTS_DIR_NAME"
[ ! -v DOTFILES_BACKUP_DIR_NAME ] && declare -r DOTFILES_BACKUP_DIR_NAME="backup"
[ ! -v DOTFILES_BACKUP_DIR ] && declare -r DOTFILES_BACKUP_DIR="$DOTFILES_ROOT_DIR/$DOTFILES_BACKUP_DIR_NAME"
[ ! -v DOTFILES_BASH_COMPLETIONS_DIR ] && declare -r DOTFILES_BASH_COMPLETIONS_DIR="$HOME/.local/share/bash-completion/completions"

# ----------------------------------------------------------------------
# | Topics                                                             |
# ----------------------------------------------------------------------

[ ! -v TOPIC_INIT_FILE ] && declare -r TOPIC_INIT_FILE="init.sh"
[ ! -v TOPIC_SETUP_FILE ] && declare -r TOPIC_SETUP_FILE="setup.sh"

load_topics() {

	local -r SOURCE_DIR=$1
	local -a TOPICS_TO_LOAD=$(find $SOURCE_DIR -mindepth 2 -maxdepth 2 -type f -name $TOPIC_INIT_FILE -exec dirname {} \; 2>/dev/null)

	for i in ${TOPICS_TO_LOAD[@]}; do

		source "$i/$TOPIC_INIT_FILE"

	done

}

setup_topics() {

	local -r SOURCE_DIR=$1
	local -a TOPICS_TO_SETUP=$(find $SOURCE_DIR -mindepth 2 -maxdepth 2 -type f -name $TOPIC_SETUP_FILE -exec dirname {} \; 2>/dev/null)

	for i in ${TOPICS_TO_SETUP[@]}; do

		execute "source $i/$TOPIC_SETUP_FILE && main" "Setting up $(basename $i) ..."

	done

}

# ----------------------------------------------------------------------
# | Misc                                                               |
# ----------------------------------------------------------------------

[ ! -v ARCH ] && declare -r ARCH="amd64"
[ ! -v PACKAGE_EXTENSION ] && declare -r PACKAGE_EXTENSION=".deb"
[ ! -v PACKAGE_MANAGER ] && declare -r PACKAGE_MANAGER="apt"

ask_for_sudo() {

    # Ask for the administrator password upfront.

    sudo -v &>/dev/null

    # Update existing `sudo` time stamp
    # until this script has finished.
    #
    # https://gist.github.com/cowboy/3118588

    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &>/dev/null &

}

cmd_exists() {
    command -v "$1" &>/dev/null
}

set_trap() {

    trap -p "$1" | grep "$2" &>/dev/null ||
        trap '$2' "$1"

}

kill_all_subprocesses() {

    local i=""

    for i in $(jobs -p); do
        kill "$i"
        wait "$i" &>/dev/null
    done

}

execute() {

    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

    local exit_code=0
    local cmds_PID=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If the current process is ended,
    # also end all its subprocesses.

    set_trap "EXIT" "kill_all_subprocesses"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Execute commands in background
    # shellcheck disable=SC2261

    eval "$CMDS" \
        &>/dev/null \
        2>"$TMP_FILE" &

    cmds_PID=$!

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Show a spinner if the commands
    # require more time to complete.

    show_spinner "$cmds_PID" "$CMDS" "$MSG"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait for the commands to no longer be executing
    # in the background, and then get their exit code.

    wait "$cmds_PID" &>/dev/null
    exit_code=$?

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Print output based on what happened.

    print_result $exit_code "$MSG"

    if [ $exit_code -ne 0 ]; then
        print_error_stream <"$TMP_FILE"
    fi

    rm -rf "$TMP_FILE"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    return $exit_code

}

sync_dotfiles() {

	if ! git rev-parse --is-inside-work-tree &>/dev/null; then
		# ======================================= #
		# case: FIRST TIME INSTALL                #
		# ======================================= #

		print_info "   [ℹ️] No DOTFILES where detected, beginning a remote install ..."

		# if directory contains anything, move it to /backups/.dotfiles except /backups, of course
		[ ! -z $(ls -A "$DOTFILES_ROOT_DIR") ] &&
			mkdir "$DOTFILES_ROOT_DIR/backups/.dotfiles" &&
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

symlink_files() {

	local -a SOURCE_FILES=("${!1}")
	local -a TARGET_FILES=("${!2}")

	local MIN_LENGTH=$((${#SOURCE_FILES[@]} < ${#TARGET_FILES[@]} ? ${#SOURCE_FILES[@]} : ${#TARGET_FILES[@]}))

	for ((i = 0; i < MIN_LENGTH; i++)); do

		local SOURCE_FILE="${SOURCE_FILES[$i]}"
		local TARGET_FILE="${TARGET_FILES[$i]}"

		if [ -e "$TARGET_FILE" ]; then

			# Backup existing file
			local BACKUP_FILE="$DOTFILES_BACKUP_DIR/${TARGET_FILE#$HOME/}"
			mkdir -p $(dirname "$BACKUP_FILE")
			mv "$TARGET_FILE" "$BACKUP_FILE"
			print_success "Backed up $TARGET_FILE to $BACKUP_FILE"

		fi

		# Create symlink
		ln -fs $SOURCE_FILE $TARGET_FILE
		print_success "$TARGET_FILE → $SOURCE_FILE"

	done

}

# ----------------------------------------------------------------------
# | Input & Output                                                     |
# ----------------------------------------------------------------------

print_in_color() {

    printf "%b" \
        "$(tput setaf "$2" 2>/dev/null)" \
        "$1" \
        "$(tput sgr0 2>/dev/null)"

}

print_in_green() {
    print_in_color "$1" 2
}

print_in_purple() {
    print_in_color "$1" 5
}

print_in_red() {
    print_in_color "$1" 1
}

print_in_yellow() {
    print_in_color "$1" 3
}

print_in_blue() {
    print_in_color "$1" 4
}

print_error() {
    print_in_red "   [✖] $1 $2\n"
}

print_error_stream() {

    while read -r line; do
        print_error "↳ ERROR: $line"
    done

}

print_info() {
    print_in_blue "   [ℹ️] $1\n"
}

print_success() {
    print_in_green "   [✔] $1\n"
}

print_warning() {
    print_in_yellow "   [!] $1\n"
}

print_result() {

    if [ "$1" -eq 0 ]; then
        print_success "$2"
    else
        print_error "$2"
    fi

    return "$1"

}

show_spinner() {

    local -r FRAMES='⠇⠋⠙⠸⠴⠦'
    local -r NUMBER_OF_FRAMES=${#FRAMES}

    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"

    local i=0
    local frame_text=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Provide more space so that the text hopefully
    # doesn't reach the bottom line of the terminal window.
    #
    # This is a workaround for escape sequences not tracking
    # the buffer position (accounting for scrolling).
    #
    # Only used in interactive shells.
    #
    # See also: https://unix.stackexchange.com/a/278888

    if [ -t 0 ]; then
        printf "\n\n\n"
        tput cuu 3
        tput sc
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Display a message without spinner animation
    # in non-interactive shells.

    if [ ! -t 0 ]; then
        printf "%s\n" "   [ℹ️] $MSG"
        return
    fi

    # Display spinner while the commands are being executed
    # in an interactive shell.

    while kill -0 "$PID" &>/dev/null; do

        frame_text="   [${FRAMES:i++%NUMBER_OF_FRAMES:1}] $MSG"

        # Print frame text.

        printf "%s\n" "$frame_text"

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        sleep 0.2

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Clear frame text.

        tput rc

    done

}
