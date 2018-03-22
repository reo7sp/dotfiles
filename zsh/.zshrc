# env
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
export PATH="$HOME/g/Exec/scripts:$PATH"
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

export DOKKU_HOST=  # Fill it with your data


# plugins
source <(antibody init)
antibody bundle mafredri/zsh-async
antibody bundle sindresorhus/pure
antibody bundle zsh-users/zsh-completions
antibody bundle zsh-users/zsh-autosuggestions
antibody bundle zuxfoucault/colored-man-pages_mod
antibody bundle djui/alias-tips
antibody bundle reo7sp/zimfw-git
antibody bundle reo7sp/zimfw-git folder:functions kind:path
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


# misc
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic


# aliases
## general
alias l="ls"
alias ll="ls -lh"
alias la="ls -a"
alias lla="ls -lah"
alias grep="grep --color=auto"
alias _="sudo"
alias rm="rm -f"
alias cp="cp -f"
alias mv="mv -f"
alias h="history 1"
alias lcd="cd \$(pwd -P)"
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
alias edit-zsh="vim ~/.zshrc; source ~/.zshrc"
alias time-zsh="time zsh -i -c exit"
alias edit-pzsh="vim ~/.proj.zshrc; source ~/.proj.zshrc"
alias show-pzsh="cat ~/.proj.zshrc"

## vim
if can-exec nvim; then
  alias vim="nvim"
fi
alias edit-vim="vim ~/.vimrc"
alias time-vim="time vim -c ':e ~/.zshrc | :q!'"

## git
if can-exec hub; then
  alias git=hub
fi
alias ghelp="less $(antibody list | grep zimfw-git)/init.zsh"

## dokku
#alias dokku="ssh -t dokku@\$DOKKU_HOST --"
#alias dokku-git-init="git remote remove dokku 2>/dev/null; git remote add dokku dokku@\$DOKKU_HOST:\${\$(pwd)##*/}; git remote -v | grep --color=never dokku"

## ssh
alias copy-ssh="cat ~/.ssh/id_rsa.pub | pbcopy"
alias edit-ssh="vim ~/.ssh/config"
alias show-ssh="cat ~/.ssh/config"

## jupyter
alias jn="jupyter notebook"
alias jc="jupyter console"

## mac
alias reset-launchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"

## network
alias check-net="curl https://files.reo7sp.ru/check-net/check-net.html"
alias bauman-wifi="http --form POST https://lbpfs.bmstu.ru:8003/index.php\?zone\=bmstu_lb redirurl=/ auth_user=??? auth_pass=??? accept=Continue"
alias show-ports="lsof -iTCP -sTCP:LISTEN -n -P"

## random
alias random-string="openssl rand -base64 12"

## home page
alias edit-home="vim $HOME/m/code/home/index.html; echo; confirm 'Commit?' && commit-home"
alias commit-home="cd $HOME/m/code/home && git add -A && git commit -m \"\$(date)\" && gp && cd -"


# custom for projects

if [[ -f ~/.proj.zshrc ]]; then
  source ~/.proj.zshrc
fi


# custom

export GOPATH="$HOME/Documents/code/_go"
export PATH="$GOPATH/bin:$PATH"


if can-exec virtualenvwrapper; then
else
  if [[ -f /usr/local/bin/virtualenvwrapper.sh ]]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
    source /usr/local/bin/virtualenvwrapper.sh
  fi
fi


if can-exec nvm; then
else
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
fi
export PATH="/usr/local/opt/openssl/bin:$PATH"
