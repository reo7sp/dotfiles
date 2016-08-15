# functions
canexec() {
  local command=$(echo $1 | awk '{print $1;}')
  hash $command 2>/dev/null
}

apip() {
  echo 'pip:'
  pip "$@"
  echo 'pip3:'
  pip3 "$@"
}

# settings
export HISTCONTROL=erasedups:ignorespace
ZSH_THEME="robbyrussell"
ENABLE_CORRECTION=true
COMPLETION_WAITING_DOTS=true
DISABLE_UPDATE_PROMPT=true

# plugins
plugins=(common-aliases colored-man-pages fancy-ctrl-z dirhistory cp z git github rails)

# env
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if canexec nvim; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

export DOKKU_HOST= # Fill it with your data

# aliases
alias :e="env REOVIMRC_LIGHT=1 vim"
alias :E="env REOVIMRC_LIGHT=0 vim"
alias vi="vim"
alias lvim="env REOVIMRC_LIGHT=1 vim"
alias hvim="env REOVIMRC_LIGHT=0 vim"
if canexec nvim; then
  alias :e="nvim"
  alias :E="env REOVIMRC_LIGHT=0 nvim"
  alias vi="nvim"
  alias vim="nvim"
  alias lvim="env REOVIMRC_LIGHT=1 nvim"
  alias hvim="env REOVIMRC_LIGHT=0 nvim"
fi
if canexec mvim; then
  alias :E="env REOVIMRC_LIGHT=0 mvim"
  alias hvim="env REOVIMRC_LIGHT=0 mvim"
fi

alias :q="exit"
alias :wq="exit"

alias mkcd="take"

alias ssh-add="eval \`ssh-agent -s\`; ssh-add -l > /dev/null || ssh-add"
alias tmux="tmux -2"

alias dokku="ssh -t dokku@\$DOKKU_HOST --"
alias dokku-git-init="git remote remove dokku 2>/dev/null; git remote add dokku dokku@\$DOKKU_HOST:\${\$(pwd)##*/}; git remote -v | grep --color=never dokku"

alias jn="jupyter notebook"
alias jc="jupyter console"

alias edit-vim="$EDITOR ~/.vimrc"
alias edit-zsh="$EDITOR ~/.oh-my-zsh/config/my.zsh; source ~/.zshrc"

alias update-vim="REOVIMRC_LIGHT=0 vim -c ':PlugUpdate | :qa!'; REOVIMRC_LIGHT=1 vim -c ':PlugUpdate | :qa!'"
alias update-zsh="upgrade_oh_my_zsh"
alias update-brew="brew update && brew upgrade"
alias update-apt="sudo apt-get update && sudo apt-get upgrade"

