#!/usr/bin/env zsh

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
  echo "------"
  # nvim
  echo ">> Installing & setting up neovim"
  _ensure_installed "nvim"
  _create_symlink ".config/nvim/init.vim"
  # vim-plug
  echo ">> Installing vim-plug [always reinstall]"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  echo ">> Installing neovim plugins (:PlugInstall)"
  nvim -c 'PlugInstall' -c 'qa'
  echo "------"
}

main "$@"
