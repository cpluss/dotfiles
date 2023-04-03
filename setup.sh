#!/usr/bin/env bash

function _ensure_brew_installed() {
  # Check if brew is already installed, and if so
  # don't do anything
  if [ -x "$(command -v brew)" ]; then
    return 0
  fi

  # Ensure we're running OSX
  local arch=$(uname)
  if [$arch != "Darwin"]; then
    echo "Can not install homebrew on $arch"
    exit 1
  fi

  # Install using the "official" method from https://brew.sh/
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  return 0
}

function _ensure_installed() {
  local to_install=$1

  # First off check if $to_install is already
  # installed, if so skip this
  if [ -x "$(command -v $to_install)" ]; then
    return 0
  fi

  local arch=$(uname)
  if [$arch = "Darwin"]; then
    _ensure_brew_installed
    brew install $1
  elif [$arch = "Linux"]; then
    if ! [ -x "$(command -v apt)" ]; then
      echo "Can not find apt, can not proceed with installing $to_install."
      exit 1
    fi

    sudo apt install -y $to_install
  else
    echo "Unknown arch: $arch, can not proceed with installing $to_install."
    exit 1
  fi
}

function _create_symlink() {
  local relative_path=$1

  local target="$HOME/$relative_path"
  local source="$(pwd)/$relative_path"

  # Remove the target & create a backup
  # before linking to ensure it always works.
  if ! [[ -L $target ]] && [[ -f $target ]]; then
    # Target exists & is not a symlink
    echo ">>>> $target already exists, removing"
    mv $target $target.bak
    rm -rf $target
    echo ">>>> $target backed up to $target.bak"
  elif [[ -L $target ]]; then
    echo ">>>> $relative_path already symlinked"
    return 0
  fi

  echo ">>>> linking $target -> $source"
  ln -sn "$source" "$target"
}

function main() {
  # tooling
  echo ">> Installing toolsets / cli"
  _ensure_installed "ripgrep curl zsh neovim jq yq tmux tree-sitter"
  
  # desktop apps
  echo ">> Installing desktop apps"
  _ensure_installed "spotify firefox iterm2 visual-studio-code"

  # setup neovim
  echo ">> Setting up neovim"
  git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
  git clone https://github.com/cpluss/astronvim.git ~/.config/nvim/lua/user
  nvim -c 'Lazy check' -c 'Lazy update' -c 'qa'

  echo ">> Setting up zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
  _create_symlink ".zshrc"
  _create_symlink ".p10k.zsh"
}

main "$@"
