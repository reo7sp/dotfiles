# settings
export HISTCONTROL=erasedups:ignorespace
ZSH_THEME="robbyrussell"
ENABLE_CORRECTION=true
COMPLETION_WAITING_DOTS=true
DISABLE_UPDATE_PROMPT=true

plugins=(common-aliases colored-man-pages fancy-ctrl-z git github cp colorize)


# functions
## generic
canexec() {
  local command=$1
  hash $command 2>/dev/null
}

newtmp() {
  take "$HOME/m/oneoff-code/$(date '+%Y-%m-%d')"
}

findalias() {
  local args=("$@")
  local len=${#args[@]}
  local code=1
  while [[ "$code" != 0 && "$len" != 0 ]]; do
    alias | grep --color=always -i "$args[*]"
    code=$?
    args=${args[@]:0:$len-1}
    ((len--))
  done
}

apip() {
  echo "pip2:"
  pip2 "$@"
  echo "pip3:"
  pip3 "$@"
}

## git
gds() {
  gd --color "$@" | diff-so-fancy | less
}


# aliases
## generic
alias ccat="colorize"
alias mkcd="take"
alias a="findalias"

## vim
alias :e="env REOVIMRC_LIGHT=1 vim"
alias :E="env REOVIMRC_LIGHT=0 vim"
alias vi="vim"
alias lvim="env REOVIMRC_LIGHT=1 vim"
alias hvim="env REOVIMRC_LIGHT=0 vim"
if canexec nvim; then
  alias vim="nvim"
  alias :e="nvim"
  alias :E="env REOVIMRC_LIGHT=0 nvim"
  alias vi="nvim"
  alias lvim="env REOVIMRC_LIGHT=1 nvim"
  alias hvim="env REOVIMRC_LIGHT=0 nvim"
fi
alias :q="exit"
alias :wq="exit"

## git
alias git-shortcuts="cat ~/.oh-my-zsh/plugins/git/git.plugin.zsh"

## ssh
alias copy-ssh="cat ~/.ssh/id_rsa.pub | pbcopy"

## tmux
alias tmux="tmux -2"

## dokku
alias dokku="ssh -t dokku@\$DOKKU_HOST --"
alias dokku-git-init="git remote remove dokku 2>/dev/null; git remote add dokku dokku@\$DOKKU_HOST:\${\$(pwd)##*/}; git remote -v | grep --color=never dokku"

## jupyter
alias jn="jupyter notebook"
alias jc="jupyter console"

## mac
alias reset-launchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
alias battery="pmset -g batt"

## network
alias check-net="curl http://reo7sp.ru/check-net.html"

## bmstu
alias bauman-wifi="http --form POST https://lbpfs.bmstu.ru:8003/index.php\?zone\=bmstu_lb redirurl=/ auth_user=??? auth_pass=??? accept=Continue"

## edit config
alias edit-vim="vim ~/.vimrc"
alias edit-vim-inst="vim ~/.vimrc.user.install"
alias edit-zsh="vim ~/.oh-my-zsh/config/my.zsh; source ~/.zshrc"
alias edit-zshrc="vim ~/.zshrc; source ~/.zshrc"

## update
alias update-vim="REOVIMRC_LIGHT=0 vim -c ':PlugUpdate | :qa!'; REOVIMRC_LIGHT=1 vim -c ':PlugUpdate | :qa!'"
alias update-zsh="upgrade_oh_my_zsh"
alias update-brew="brew update && brew upgrade"
alias update-apt="sudo apt-get update && sudo apt-get upgrade"


# env
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
export PATH="$HOME/g/Exec/scripts:$PATH"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if canexec nvim; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

export DOKKU_HOST=  # Fill it with your data

export GOPATH="$HOME/m/code/_go"
