#!/bin/bash
set -e -o pipefail

zsh -c '
  source "$HOME/.antidote/antidote.zsh"
  eval "$(antidote bundle catppuccin/zsh-fsh kind:path)" >/dev/null 2>&1

  theme_dir="$HOME/.config/fsh"
  catppuccin_dir="$(antidote path catppuccin/zsh-fsh)/themes"
  mkdir -p "$theme_dir"
  ln -sf "$catppuccin_dir"/catppuccin-*.ini "$theme_dir"/

  eval "$(antidote bundle zdharma-continuum/fast-syntax-highlighting)" >/dev/null 2>&1
  fast-theme -r
  fast-theme XDG:catppuccin-latte
'
