#!/bin/bash

# Append to the history file, rather than overwriting it.
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Use extended pattern matching features.
shopt -s extglob

# Do not attempt to search the PATH for possible completions when
# completion is attempted on an empty line.
shopt -s no_empty_cmd_completion

# Match filenames in a case-insensitive fashion when performing
# filename expansion.
shopt -s nocaseglob

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

