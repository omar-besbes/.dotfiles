#!/bin/bash

# Append to the history file, rather than overwriting it.
shopt -s histappend

# Save multi-line commands as one command.
shopt -s cmdhist

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

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell

# Correct spelling errors during tab-completion
shopt -s dirspell direxpand

# Automatically change to the directory if only one match is found
shopt -s autocd

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# Huge history. Doesn't appear to slow things down so why not ?
HISTSIZE=500000
HISTFILESIZE=100000

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '

# This defines where cd looks for targets.
# Add the directories you want to have fast access to, separated by colon.
# Ex: CDPATH=".:~:~/Documents" will look for targets in the current working directory, in home and in the ~/Documents folder
CDPATH="."

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2
