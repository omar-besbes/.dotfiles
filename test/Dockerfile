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

# Create user
RUN adduser --disabled-password --gecos '' omar
RUN passwd -d omar
RUN usermod -aG sudo omar
USER omar
WORKDIR /home/omar

# Copy local dotfiles or prepare for remote clone
COPY --chown=omar:omar . /tmp/.dotfiles

# ARG to control source: "local" or "remote"
ARG SOURCE
RUN if [ "$SOURCE" = "local" ]; then \
    mv /tmp/.dotfiles /home/omar/.dotfiles; \
    else \
    rm -rf /tmp/.dotfiles; \
    fi
