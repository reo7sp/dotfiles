source <(antibody init)


# plugins
antibody bundle mafredri/zsh-async
antibody bundle sindresorhus/pure
antibody bundle zsh-users/zsh-completions
antibody bundle zsh-users/zsh-autosuggestions
antibody bundle zuxfoucault/colored-man-pages_mod
antibody bundle djui/alias-tips
antibody bundle reo7sp/oh-my-zsh-git


# functions
can-exec() {
  hash "$@" 2>/dev/null
}

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


# env
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
export PATH="$HOME/g/Exec/scripts:$PATH"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if can-exec nvim; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

export DOKKU_HOST=  # Fill it with your data

export GOPATH="$HOME/m/code/_go"


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


# ctrl-w delete to slash
autoload -U select-word-style
select-word-style bash


# colors
export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true


# aliases
## config
alias edit-zsh="vim ~/.zshrc; source ~/.zshrc"
alias edit-vim="vim ~/.vimrc"
alias time-zsh="time zsh -i -c exit"
alias time-vim="time vim -c ':e ~/.vimrc | :q!'"

## general
alias l="ls -lh"
alias grep="grep --color=auto"
alias _="sudo"

## vim
alias vi="vim"
if can-exec nvim; then
  alias vim="nvim"
  alias vi="nvim"
fi

## dokku
alias dokku="ssh -t dokku@\$DOKKU_HOST --"
alias dokku-git-init="git remote remove dokku 2>/dev/null; git remote add dokku dokku@\$DOKKU_HOST:\${\$(pwd)##*/}; git remote -v | grep --color=never dokku"

## ssh
alias copy-ssh="cat ~/.ssh/id_rsa.pub | pbcopy"

## jupyter
alias jn="jupyter notebook"
alias jc="jupyter console"

## mac
alias reset-launchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"

## network
alias check-net="curl http://reo7sp.ru/check-net.html"
alias bauman-wifi="http --form POST https://lbpfs.bmstu.ru:8003/index.php\?zone\=bmstu_lb redirurl=/ auth_user=??? auth_pass=??? accept=Continue"

## git
alias git=hub
