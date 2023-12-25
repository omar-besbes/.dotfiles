#!/bin/bash

[ ! -v TOPIC_INIT_FILE ] && declare -r TOPIC_INIT_FILE="init.sh"

load_topics() {
	
	local -r SOURCE_DIR=$1
	local -a TOPICS_TO_LOAD=$(find $SOURCE_DIR -mindepth 2 -maxdepth 2 -type f -name $TOPIC_INIT_FILE -exec dirname {} \; 2>/dev/null)

	for i in ${TOPICS_TO_LOAD[@]}; do

		source "$i/$TOPIC_INIT_FILE"

	done

}

