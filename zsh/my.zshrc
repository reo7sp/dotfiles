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
export PATH="$HOME/.antibody:$PATH"
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
## alt-b, alt-f
bindkey '\eb' backward-word
bindkey '\ef' forward-word
## ctrl-u
bindkey '^U' backward-kill-line
## suggest accept
bindkey '^J' autosuggest-accept
## history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^R' history-incremental-search-backward


# glob
unsetopt nomatch


# aliases
## general
alias ll="ls -lh"
alias la="ls -a"
alias lla="ls -lah"

alias lcd="cd \$(pwd -P)"

mkcd() {
  mkdir -p "$@"
  cd "$@"
}

new-tmp() {
  mkcd "$HOME/m/oneoff-code/$(date '+%Y-%m-%d')"
}

alias grep="grep --color=auto"
alias l="less"

if can-exec colordiff; then
  alias diff='colordiff'
fi

alias rm="rm -f"
alias cp="cp -f"
alias mv="mv -f"

alias _="sudo"
alias suz="su -m -c zsh"
alias sudz="sudo ZDOTDIR=\$HOME PATH=\$PATH zsh"

alias h="history 1"

hs() {
  history 1 | grep "$@"
}

## vim
if can-exec nvim; then
  _vim() {
    nvim "$@"
  }
else
  if [[ -z $real_vim ]]; then
    real_vim=$(which vim)
  fi
  _vim() {
    $real_vim "$@"
  }
fi
alias vim="_vim"
alias v="_vim"

alias edit-vim="vim ~/.vimrc"
alias time-vim="time vim -c ':e ~/.zshrc | :q!'"

## zsh
alias edit-zsh="vim ~/.my.zshrc; source ~/.zshrc"
alias edit-zshrc="vim ~/.zshrc; source ~/.zshrc"
alias time-zsh="time zsh -i -c exit"

## ssh
alias copy-ssh="cat ~/.ssh/id_rsa.pub | pbcopy"
alias edit-ssh="vim ~/.ssh/config"
alias show-ssh="cat ~/.ssh/config"

sshz() {
  ssh -t "$1" zsh
}

## git
if can-exec hub; then
  alias git=hub
fi

alias aliases-git="less $(antibody list | grep zimfw-git)/init.zsh"

gfcd() {
  local repo=$1
  git clone "$repo"
  local repo=${repo##*/}
  local repo=${repo%.git}
  cd "$repo"
}

alias gcwip="git add -A && git commit -m 'wip'"
alias gcu="git add -A && git commit --amend --reuse-message HEAD"

alias gh="tig"

## fzf
alias f="fzf"

## sublime text
t() {
  if [[ -z $1 ]]; then
    subl .
  else
    subl "$@"
  fi
}

## tmux
tt() {
  tmux -2 a || tmux -2 new
}

ttcl() {
  clear
  tmux clear-history
}

## python
alias jn="jupyter notebook"
alias jc="jupyter console"
alias py="python"
alias p2="python2"
alias p3="python3"
alias pt="python -m ptpython"
alias pt2="python2 -m ptpython"
alias pt3="python3 -m ptpython"

## macos
alias reset-launchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"

mount-ntfs() {
  sudo mkdir -p /Volumes/NTFS
  sudo /usr/local/bin/ntfs-3g "$1" /Volumes/NTFS -olocal -oallow_other
}

## network
alias check-net="curl https://files.olezh.es/check-net/check-net.html"
alias bauman-wifi="http --form POST https://lbpfs.bmstu.ru:8003/index.php\?zone\=bmstu_lb redirurl=/ auth_user=??? auth_pass=??? accept=Continue"

if [[ $IS_MACOS -eq 1 ]]; then
  alias show-ports="lsof -iTCP -sTCP:LISTEN -n -P"
else
  alias show-ports="netstat -tulpn"
fi

alias edit-hosts="vim /etc/hosts"
alias show-hosts="cat /etc/hosts"

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

## util
random-string() {
  openssl rand -hex "$1"
}

timestamp() {
  date +%s
}

