#!/bin/bash

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
