# Use the latest netinst image of debian
FROM	debian:stable-slim

# Install necessary dependencies
RUN	apt-get update && \
		apt-get install -y \
			sudo \
			git \
			kmod \
			fuse

# Set root home directory
ENV	ROOT_DIR="/root"

# Get latest stable version of dotfiles
ENV	DOTFILES_GITHUB_ORIGIN="https://github.com/omar-besbes/.dotfiles.git"
COPY  . ${ROOT_DIR}/.dotfiles

# Set the working directory to root's home directory
WORKDIR	${ROOT_DIR}/.dotfiles

# Run the bootstrap script and then bash if started interactively
CMD ["bash", "-c", "./bootstrap.sh && (test -t 0 && exec bash || true)"]
#CMD	["./bootstrap.sh", "&&", "/bin/bash"]

