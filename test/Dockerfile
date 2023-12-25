# Use the latest netinst image of debian
FROM	debian:stable-slim

# Install necessary dependencies
RUN	apt-get update && \
		apt-get install -y \
			sudo \
			git \
			kmod \
			curl \
			fuse

# Set root home directory
ENV	ROOT_DIR="/root"

# Get current version of dotfiles
COPY  . ${ROOT_DIR}/.dotfiles

# Set the working directory to root's home directory
WORKDIR	${ROOT_DIR}/.dotfiles

# Run the bootstrap script and then bash if started interactively
CMD ["/bin/bash", "-c", "./bootstrap.sh && ./test/test.sh"]

