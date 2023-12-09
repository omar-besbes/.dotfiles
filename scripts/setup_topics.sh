#!/bin/bash

declare -r TOPIC_SETUP_FILE="setup.sh"

load_topics() {
	
	local -r SOURCE_DIR=$1
	local -a TOPICS_TO_SETUP=$(find $SOURCE_DIR -mindepth 2 -maxdepth 2 -type f -name $TOPIC_SETUP_FILE -exec dirname {} \; 2>/dev/null)

	for i in ${TOPICS_TO_SETUP[@]}; do

		source "$i/$TOPIC_SETUP_FILE"

	done

}

