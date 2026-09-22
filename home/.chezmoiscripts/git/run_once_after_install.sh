#!/bin/bash
set -e -o pipefail

confirm() {
  local response
  read -r -p "$1 [y/N] " response
  [[ $response =~ ^[yY]([eE][sS])?$ ]]
}

git config --global init.defaultBranch master
git config --global core.excludesfile "$HOME/.gitignore_global"
git config --global merge.conflictStyle zdiff3

if confirm "git: Change global user.name and user.email?"; then
  git config --global user.name "Oleg Morozenkov"
  git config --global user.email "m@oleg.rocks"
fi

if confirm "git: Change GitHub transport from HTTPS to SSH?"; then
  git config --global --replace-all url.ssh://git@github.com/.insteadOf https://github.com/
  git config --global --add url.ssh://git@github.com/.insteadOf https://reo7sp@github.com/
fi

if confirm "git: Change pager to delta?"; then
  git config --global core.pager delta
  git config --global interactive.diffFilter 'delta --color-only'
  git config --global delta.navigate true
  git config --global delta.light true
  git config --global merge.conflictStyle zdiff3
fi

if confirm "git: Change diff tool to difftastic?"; then
  git config --global diff.external difft
  git config --global diff.tool difftastic
  git config --global difftool.difftastic.cmd 'difft "$MERGED" "$LOCAL" "abcdef1" "100644" "$REMOTE" "abcdef2" "100644"'
  git config --global difftool.prompt false
  git config --global pager.difftool true
fi

if confirm "git: Change merge tool to Sublime Merge?"; then
  git config --global merge.tool smerge
fi
