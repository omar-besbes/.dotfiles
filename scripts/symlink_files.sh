#!/bin/bash

symlink_files() {
	
	local -a FILES_TO_SYMLINK=("${!1}")
	local -r SOURCE_DIR="$2"
	local -r TARGET_DIR="$3"
	local -r GET_TARGET_FILE="$4"

	for i in "${FILES_TO_SYMLINK[@]}"; do

		local SOURCE_FILE="$SOURCE_DIR/$i"
		local TARGET_FILE="$TARGET_DIR/$($GET_TARGET_FILE $i 2>/dev/null || echo $i)"

      if [ ! -e "$TARGET_FILE" ]; then

			ln -fs $SOURCE_FILE $TARGET_FILE
			echo "$TARGET_FILE → $SOURCE_FILE"

      fi
		
    done

}

