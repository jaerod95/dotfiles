#! /usr/bin/env bash

set -e

function install-brew-packages() {
  brew bundle --file ~/.dotfiles/Brewfile
}

function main() {
  install-brew-packages
}

main $@
