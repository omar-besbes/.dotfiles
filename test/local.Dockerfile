# Use the latest netinst image of debian
FROM debian:stable-slim

# Install necessary dependencies
RUN	apt-get update && \
	apt-get install -y \
	git \
	sudo \
	curl \
	gnupg \
	fuse

ENV SHELL=bash

# Copy dotfiles to root's home directory
COPY . /root/.dotfiles
