# Use the latest netinst image of debian
FROM	debian:stable-slim

# Install necessary dependencies
RUN	apt-get update && \
		apt-get install -y \
			sudo \
			git \
			kmod \
			fuse

# Get latest stable version of dotfiles
RUN	git clone https://github.com/omar-besbes/.dotfiles.git /root/.dotfiles

# Set the working directory
WORKDIR	/root/.dotfiles

# Run the bootstrap script
CMD	["./bootstrap.sh"]

