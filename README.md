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
- Chromium the open-source browser with the best of Chrome minus the proprietary bits
- Well-organized and easy to customize
- The installation and setup is
  [tested on a debian container](https://github.com/omar-besbes/.dotfiles/actions)


## Setup


> [!WARNING]
> This setup was only tested on `debian`. <br>
> The installation of `chromium` is expected to fail on `ubuntu`.


Only `bash`, `apt`, `sudo` and `curl` are required. The script will install everything else by itself.

Run this:
```sh
bash <(curl -fSL# https://raw.githubusercontent.com/omar-besbes/.dotfiles/main/dotfiles.sh) install && . ~/.bashrc
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
* dotfiles.sh - Dotfiles CLI

### Scripts (scripts/)
The `/scripts` directory contains executable shell scripts (including the dotfiles script) and symlinks to executable shell scripts.
This directory is added to the path.
* install.sh - Calls all `setup.sh` scripts
* backup.sh - Calls all `backup.sh` scripts
* restore.sh - Calls all `restore.sh` scripts
* utils.sh – Contains helper functions for:
  - printing progress messages
  - calling all `init.sh` or `setup.sh` scripts in a directory
  - symlinking files
  - synchronizing the current dotfiles repository with the remote

### Source (src/)
The `/src` directory contains all topics configurations.
A topic is basically a folder with configuration for a piece of software that must have a `setup.sh` file as an entry point.
Each topic is responsible for setting up itself and should not depend on other topics.
All other folders inside `src` without `setup.sh` are ignored and are not considered topics.

### Browser (src/browser/)
* setup.sh - Calls chromium's `setup.sh`.
* brave/
  * setup.sh - Installs [brave](https://brave.com).
* chromium/
  * setup.sh - Installs [chromium](https://www.chromium.org).
* opera/
  * setup.sh - Installs [opera](https://opera.com).

### Docker (src/docker/)
* setup.sh - Installs [Docker](https://docker.com).

### Fonts (src/fonts/)
* setup.sh - Installs the following [Nerd Fonts](https://www.nerdfonts.com): `Hack`, `JetBrainsMono`, `RobotoMono`, `NerdFontsSymbolsOnly`.

### Git (src/git/)
* setup.sh - Symlinks all git files to `~`.
* gitconfig - Sets several global Git variables (.gitconfig).

### Helm (src/helm/)
* setup.sh - Installs [helm](https://helm.sh).

### Kubectl (src/kubectl/)
* setup.sh - Installs [kubectl](https://kubernetes.io).

### Shell (src/shell/)
* setup.sh - Symlinks all fish files to their corresponding location in `~` and calls all sub-`setup.sh`.
* bash_logout - Cleans up on shell logout (.bash_logout).
* bash_profile - Contains bash configuration on shell login (.bash_profile).
* bashrc - Contains bash configuration on shell startup (.bashrc).
* inputrc - Contains GNU Readline configuration of command-line editing feature (.inputrc).
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

### Spotify (src/spotify/)
* setup.sh - Installs [spotify](https://spotify.com).

### Terminal emulator (src/terminal-emulator/)
* setup.sh - Calls alacritty's `setup.sh`.
* alacritty/
  * setup.sh - Installs [alacritty](https://alacritty.org) and symlinks `~/.config/alacritty/alacritty.yml` to `alacritty.yml`.
  * alacritty.yml - Contains alacritty config.

### Text Editor (src/text-editor/)

* setup.sh - Calls each editor's `setup.sh`.
* neovim/
  * setup.sh - Symlinks `~/.config/nvim` to `src/text-editors/neovim/nvim`.
  * nvim/ - My Neovim config as a git submodule. Checkout the [repository](https://github.com/omar-besbes/nvim-config).
* vscode/
  * setup.sh - Installs [Visual Studio Code](https://code.visualstudio.com).
* vscodium/
  * setup.sh - Installs [VSCodium](https://vscodium.com).

### Tests (test/)
The `/test` directory contains tests.
* test.sh - Contains tests to be run inside the container.
* docker-compose.yml - Contains a description of the test environments. 
There are 2 test environments: one that clones the repository and another that runs the install command in `README.md`.
* Dockerfile - Contains instructions to build a docker image of the test environment.

### Backups (backups/)
The `/backups` directory gets created when necessary. Any files in `~/` that would have been overwritten during installation get backed up there.


## Todo


- [x] Git
- [x] Shell
- [x] Text editor
- [x] Prompt
- [x] Terminal emulator
- [x] Automated tests
- [x] Remote install
- [x] Fonts
- [x] Web browser
- [x] CLI
- [ ] Automatic bookmarks import in browser
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
