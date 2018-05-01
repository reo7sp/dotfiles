# env
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

can-exec() {
  which "$1" 2>/dev/null 1>/dev/null
}

confirm() {
  local message=$1

  echo -n -e "${BWhite}$message${Color_Off} [Y/n] "
  read response
  case $response in
    [yY][eE][sS]|[yY]|"")
      true
      ;;
    *)
      false
      ;;
  esac
}

if can-exec nvim; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi


if uname -a | grep Darwin > /dev/null; then
  export IS_MACOS=1
else
  export IS_MACOS=0
fi


# plugins
source <(antibody init)
antibody bundle mafredri/zsh-async
antibody bundle sindresorhus/pure
antibody bundle zsh-users/zsh-completions
antibody bundle zsh-users/zsh-autosuggestions
antibody bundle zuxfoucault/colored-man-pages_mod
antibody bundle djui/alias-tips
antibody bundle reo7sp/zimfw-git
export PATH="$(antibody list | grep zimfw-git)/functions:$PATH"
antibody bundle zsh-users/zsh-history-substring-search


# history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=2500
export SAVEHIST=$HISTSIZE
## add timestamps to history
setopt EXTENDED_HISTORY
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
## adds history
setopt APPEND_HISTORY
## adds history incrementally and share it across sessions
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
## don't record dupes in history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST


# colors
export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true


# keybinds
## shift-tab : go backward in menu (invert of tab)
bindkey '^[[Z' reverse-menu-complete
## ctrl-w delete to slash
autoload -U select-word-style
select-word-style bash
## ctrl-a, ctrl-e
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
## suggest accept
bindkey '^J' autosuggest-accept
## history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^R' history-incremental-search-backward


# glob
unsetopt extended_glob
setopt no_extended_glob
setopt no_bare_glob_qual
setopt NO_NOMATCH


# aliases
## general
alias l="ls"
alias ll="ls -lh"
alias la="ls -a"
alias lla="ls -lah"
alias grep="grep --color=auto"
alias g="grep --color=auto"
alias rm="rm -f"
alias cp="cp -f"
alias mv="mv -f"
alias h="history 1"
alias lcd="cd \$(pwd -P)"
alias _="sudo"
alias tosudo="sudo ZDOTDIR=\$HOME zsh"

mkcd() {
  mkdir -p "$@"
  cd "$@"
}

new-tmp() {
  mkcd "$HOME/m/oneoff-code/$(date '+%Y-%m-%d')"
}

quick-look() {
  (( $# > 0 )) && qlmanage -p $* &>/dev/null &
}

## zsh
alias edit-zsh="vim ~/.my.zshrc; source ~/.zshrc"
alias edit-zshrc="vim ~/.zshrc; source ~/.zshrc"
alias time-zsh="time zsh -i -c exit"

## vim
if can-exec nvim; then
  _vim() {
    nvim "$@"
    if [[ $IS_MACOS == 1 ]]; then
      cursor-beam
    fi
  }
else
  real_vim=$(which vim)
  _vim() {
    $real_vim "$@"
    if [[ $IS_MACOS == 1 ]]; then
      cursor-beam
    fi
  }
fi
alias vim="_vim"
alias edit-vim="vim ~/.vimrc"
alias time-vim="time vim -c ':e ~/.zshrc | :q!'"

## ssh
alias copy-ssh="cat ~/.ssh/id_rsa.pub | pbcopy"
alias edit-ssh="vim ~/.ssh/config"
alias show-ssh="cat ~/.ssh/config"

_ssh() {
  cursor-block
  ssh "$@"
  cursor-beam
}

alias ssh="_ssh"

## git
if can-exec hub; then
  alias git=hub
fi
alias ghelp="less $(antibody list | grep zimfw-git)/init.zsh"

## dokku
dokku-at() {
  local host=$1
  shift
  ssh -t "dokku@$host" -- "$@"
}

dokku-git-init() {
  local host=$1
  git remote remove dokku 2>/dev/null; git remote add dokku "dokku@$host:${$(pwd)##*/}"
  git remote -v | grep --color=never dokku
}

## python
alias jn="jupyter notebook"
alias jc="jupyter console"
alias py="python"
alias p2="python2"
alias p3="python3"

## macos
alias reset-launchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"

mount-ntfs() {
  sudo mkdir -p /Volumes/NTFS
  sudo /usr/local/bin/ntfs-3g "$1" /Volumes/NTFS -olocal -oallow_other
}

cursor-block() {
  echo -n -e '\x1b]1337;CursorShape=0\x07'
}

cursor-beam() {
  echo -n -e '\x1b]1337;CursorShape=1\x07'
}

## network
alias check-net="curl https://files.reo7sp.ru/check-net/check-net.html"
alias bauman-wifi="http --form POST https://lbpfs.bmstu.ru:8003/index.php\?zone\=bmstu_lb redirurl=/ auth_user=??? auth_pass=??? accept=Continue"
alias show-ports="lsof -iTCP -sTCP:LISTEN -n -P"

## random
random-string() {
  openssl rand -hex "$1"
}