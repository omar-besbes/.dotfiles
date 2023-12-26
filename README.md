[My Dotfiles](repo)
===================

![Debian](https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white)

This repository contains my personal dotfiles. Take anything you want, but at your own risk.

It mainly targets debain-based distros. It is designed to be extensible, simple and modular.


## Highlights


- Neovim the next-gen vim-based text editor
- Alacritty the fast, GPU-based terminal emulator
- Bash as default shell
- Colored ls with vivid
- Fast and colored prompt with starship
- Updated git global defaults
- Well-organized and easy to customize
- The installation and setup is
  [tested on a real Ubuntu machine](https://github.com/omar-besbes/.dotfiles/actions)
  using [a GitHub Action](./.github/workflows/test.yml)


## Setup


Only `bash`, `apt`, `sudo` and `curl` are required. The script will install everything else by itself.

Run this:
```sh
bash -c 'source <(curl -# https://raw.githubusercontent.com/omar-besbes/.dotfiles/main/bootstrap.sh)' && . ~/.bashrc
```


## How "dotfiles" works

When bootstrap is run, it does a few things:

1. Git is installed if necessary via APT.
2. This repo is cloned into your user directory, under `~/.dotfiles`.
3. Various basic packages are installed if not found (e.g. curl, rustup, nvm).
4. Fonts are installed (Hack, JetBrainsMono, RobotoMono).
5. Setup each topic in `src` directory.

> [!NOTE]
> Update current shell session by running `. ~/.bashrc` to get all the good stuff :). <br>
> This is done automatically during setup.


## Contents

### Root (/)
* bootstrap.sh - Calls all `setup.sh` scripts

### Source (src/)
The `/src` directory contains all topics configurations.
A topic is basically a folder with configuration for a piece of software that must have a `setup.sh` file as an entry point.
Each topic is responsible for setting up itself and should not depend on other topics.
All other folders inside `src` without `setup.sh` are ignored and are not considered topics.

### Git (src/git/)
* setup.sh - Symlinks all git files to `~`
* gitconfig - Sets several global Git variables (.gitconfig)

### Neovim (src/neovim/)
* setup.sh - Symlinks `~/.config/nvim` to `src/neovim/nvim`
* nvim/ - My neovim config as a git submodule. Checkout the
  [repository](https://github.com/omar-besbes/nvim-config).

### Shell (src/shell/)
* setup.sh - Symlinks all fish files to their corresponding location in `~` and calls all sub-`setup.sh`.
* bash_logout - Cleans up on shell logout (.bash_logout)
* bash_profile - Contains bash configuration on shell login (.bash_profile)
* bashrc - Contains bash configuration on shell startup (.bashrc) 
* inputrc - Contains GNU Readline configuration of command-line editing feature (.inputrc)
* core/
  * init.sh - Sources all `.sh` files in the directory.
  * aliases.sh - Contains common aliases that I use daily.
  * options.sh - Contains bash shell configuration options.
  * env.sh - Sets environment variables.
  * functions.sh - Contains utilities functions that I use daily.
* bash_completion/
  * init.sh - Finds all bash completion files in `~/.bash_completion.d` and sources them.
* prompt/
  * init.sh - Sets the prompt on shell startup.
  * setup.sh - Installs [starship](https://starship.rs) and symlinks `~/.config/starship.toml` to `starship.toml`.
  * starship.toml - Contains starship config.
* ls-colors/
  * init.sh - Sets the `LS_COLORS` environment variable on shell startup using vivid.
  * setup.sh - Installs [vivid](https://github.com/sharkdp/vivid).
* welcome-screen/
  * init.sh - Displays a nice message on shell startup.
  * setup.sh - Installs [figlet](https://github.com/cmatsuoka/figlet) and [figlet fonts](https://github.com/xero/figlet-fonts).

### Terminal emulator (src/terminal-emulator/)
* setup.sh - Calls alacritty's `setup.sh`
* alacritty/
  * setup.sh - Installs [alacritty](https://alacritty.org) and symlinks `~/.config/alacritty/alacritty.yml` to `alacritty.yml`.  
  * alacritty.yml - Contains alacritty config.

### Helper Scripts (scripts/)
The `/scripts` directory contains executable shell scripts (including the dotfiles script) and symlinks to executable shell scripts.
This directory is added to the path.
* utils.sh - Contains helper functions for printing progress messages
* load_topics.sh - Contains helper function for calling all `init.sh` scripts in a directory 
* setup_topics.sh - Contains helper function for calling all `setup.sh` scripts in a directory
* symlink_files.sh - Contains helper function for symlinking files
* sync_files.sh - Contains helper function for synchronizing current dotfiles repository with remote

### Tests (test/)
The `/test` directory contains tests.
* setup.sh - Sets up a special container with all the dotfiles ready to go and runs `test.sh` inside
* test.sh - Contains tests to be run inside the container 
* Dockerfile.local - Contains instructions to build a docker image with dotfiles already installed inside
* Dockerfile.remote - Contains instructions to build a docker image similar to a new user environment and runs the same command in `README.md`.

### Backups (backups/)
The `/backups` directory gets created when necessary. Any files in `~/` that would have been overwritten during installation get backed up there.


## Todo


- [x] Automated tests
- [x] Remote install
- [ ] Move all config files in `/backups` before setup (only a small part is moved)
- [ ] Uninstall script
- [ ] Github & Gitlab SSH keys auto generation
- [ ] Mail client
- [ ] Window manger + display manager
- [ ] Other shells compatibility (only bash supported for now)


## Inspiration


This project was heavily inspired by rkalis' [dotfiles](https://github.com/rkalis/dotfiles) 
and by cătălin's [dotfiles](https://github.com/alrra/dotfiles).

Many thanks to the [dotfiles community](https://dotfiles.github.io/).


## Bugs


I want this to work for everyone; that means when you clone it down it should
work for you. 
That said, I do use this as _my_ dotfiles, so there's a good chance I may break
something if I forget to make a check for a dependency.

If you're brand-new to the project and run into any blockers, please
[open an issue](https://github.com/omar-besbes/.dotfiles/issues) on this repository
and I'd love to get it fixed for you!
