# vim: ft=zsh

# =============================================================================
# env
export PATH="$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
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

if uname -a | grep Darwin > /dev/null; then
  export IS_MACOS=1
else
  export IS_MACOS=0
fi

if can-exec nvim; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi


# =============================================================================
# plugins
export PATH="$HOME/.antibody:$PATH"
source <(antibody init)

antibody bundle mafredri/zsh-async
antibody bundle reo7sp/pure
antibody bundle zsh-users/zsh-completions
antibody bundle zsh-users/zsh-autosuggestions
antibody bundle zsh-users/zsh-history-substring-search
antibody bundle reo7sp/zimfw-git
export PATH="$(antibody list | grep zimfw | perl -lne 'print $1 if /\s+(.+)/')/functions:$PATH"
antibody bundle zuxfoucault/colored-man-pages_mod


# =============================================================================
# colors
export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true


# =============================================================================
# history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
# add timestamps to history
setopt EXTENDED_HISTORY
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
# adds history
setopt APPEND_HISTORY
# adds history incrementally and share it across sessions
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
# don't record dupes in history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST


# =============================================================================
# glob
unsetopt nomatch


# =============================================================================
# keybinds
WORDCHARS=${WORDCHARS/\/}
WORDCHARS=${WORDCHARS/_}
WORDCHARS=${WORDCHARS/|}
WORDCHARS=${WORDCHARS/-}
# shift-tab
bindkey '^[[Z' reverse-menu-complete
# ctrl-w
bindkey '^W' backward-kill-word
# ctrl-a, ctrl-e
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
# ctrl-b, ctrl-f
bindkey '^B' backward-word
bindkey '^F' forward-word
# ctrl-u
bindkey '^U' backward-kill-line
# history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^R' history-incremental-search-backward


# =============================================================================
# aliases

# -----------------------------------------------------------------------------
# general
alias ll='ls -lh'
alias la='ls -a'
alias lla='ls -lah'

alias le='less'

lcd() {
  cd "$(pwd -P)"
}

mkcd() {
  mkdir -p "$@"
  cd "$@"
}

new-tmp() {
  mkcd "$HOME/m/oneoff-code/$(date '+%Y-%m-%d')"
}

alias grep='grep --color=auto'

if can-exec colordiff; then
  alias diff='colordiff'
fi

if can-exec diff-so-fancy; then
  GIT_PAGER='diff-so-fancy'
fi

alias rm='rm -f'
alias cp='cp -f'
alias mv='mv -f'

alias _='sudo'
alias suz='su -m -c zsh'
alias sudoz="sudo ZDOTDIR=\$HOME PATH=\$PATH zsh"

if [[ $IS_MACOS -eq 1 ]]; then
  alias show-ports='lsof -iTCP -sTCP:LISTEN -n -P'
else
  alias show-ports='netstat -tulpn'
fi

alias edit-hosts='sudo vim /etc/hosts'
alias show-hosts='cat /etc/hosts'

random-string() {
  local arg=$1
  openssl rand -hex "$((arg / 2))"
}

timestamp() {
  date +%s
}

# -----------------------------------------------------------------------------
# vim
if can-exec nvim; then
  _vim() {
    lcd
    nvim "$@"
  }
else
  if [[ -z $real_vim ]]; then
    real_vim=$(which vim)
  fi
  _vim() {
    lcd
    $real_vim "$@"
  }
fi
alias vim='_vim'

v() {
  if [[ -z $1 ]]; then
    vim .
  else
    vim "$@"
  fi
}

alias edit-vim='vim ~/.vimrc'

time-start-vim() {
  vim --startuptime /tmp/startuptime.log "$@" +qa
  cat /tmp/startuptime.log
}

profile-start-vim() {
  vim --cmd 'profile start /tmp/profile.log' --cmd 'profile func *' --cmd 'profile file *' -c 'profdel func *' -c 'profdel file *' "$@" -c 'qa!'
  cat /tmp/profile.log
}

# -----------------------------------------------------------------------------
# zsh
alias edit-zsh='vim ~/.my.zshrc; source ~/.zshrc'
alias edit-zshrc='vim ~/.zshrc; source ~/.zshrc'

# -----------------------------------------------------------------------------
# kitty
alias edit-kitty="vim ~/.config/kitty/kitty.conf"

# -----------------------------------------------------------------------------
# tmux
tm() {
  tmux -2 a || tmux -2 new
}

# -----------------------------------------------------------------------------
# ssh
if [[ $TERM == 'xterm-kitty' ]]; then
  alias ssh='TERM=xterm-256color ssh'
fi

alias edit-ssh='vim ~/.ssh/config'
alias copy-ssh='cat ~/.ssh/id_rsa.pub | pbcopy'
alias show-ssh='cat ~/.ssh/config'

# -----------------------------------------------------------------------------
# git
g() {
  git "$@"
}

alias gid='git diff --cached' # remapping zimfw-git mappings to use ext-diff
alias giD='git diff --cached --word-diff'
alias gwd='git diff'
alias gwD='git diff --word-diff'
if [[ $(git config get pager.difftool 2>/dev/null) == true ]]; then
  alias gcs='git show --pretty=format:"${_git_log_medium_format}" --ext-diff'
  alias gpS='git show --pretty=short --show-signature --ext-diff'
fi

gwdn() {
  gwd --name-only "$@"
}

gcsn() {
  gcs --name-only "$@"
}

alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias gg='lazygit'
alias gll='tig'

gfcd() {
  local repo=$1
  git clone "$repo"
  local repo=${repo##*/}
  local repo=${repo%.git}
  cd "$repo"
}

alias gcu='git add -A && git commit --amend --reuse-message HEAD'

alias gcwip="git add -A && git commit -m 'wip'"
alias gcfix="git add -A && git commit -m 'fix'"
alias gckik="git add -A && git commit -m 'kik'"

alias gbd='gb -D'

gbdr() {
  echo "$@" | xargs -n1 git branch -D
  echo "$@" | xargs -n1 -P0 git push origin --delete
}

alias gfm-all="find . -maxdepth 1 -type d | xargs -n1 -t -I{} git -C '{}' pull"
alias gfr-all="find . -maxdepth 1 -type d | xargs -n1 -t -I{} git -C '{}' pull --rebase"
alias gb-all="find . -maxdepth 1 -type d | xargs -n1 -t -I{} git -C '{}' branch"

alias aliases-git="cat $(antibody list | grep zimfw-git)/init.zsh"

# -----------------------------------------------------------------------------
# difft
export DFT_CONTEXT=10
export DFT_DISPLAY=side-by-side-show-both
export DFT_PARSE_ERROR_LIMIT=9999

# -----------------------------------------------------------------------------
# fzf
alias f="fzf"

catf() {
  cat $(f)
}

lessf() {
  less $(f)
}

vimf() {
  vim $(f)
}

vf() {
  vim $(f)
}

tf() {
  t $(f)
}

cdf() {
  cd $(find . -depth 5 -type d -not -path '*/\.*' -print 2> /dev/null | fzf-tmux)
}

cdfm() {
  cd $(find .          -type d -not -path '*/\.*' -print 2> /dev/null | fzf-tmux)
}

# -----------------------------------------------------------------------------
# fd
if can-exec fdfind; then
  alias fd='fdfind'
fi

# -----------------------------------------------------------------------------
# sublime text
t() {
  lcd
  if [[ -z $1 ]]; then
    subl .
  else
    subl "$@"
  fi
}

# -----------------------------------------------------------------------------
# sublime merge
m() {
  lcd
  if [[ -z $1 ]]; then
    smerge -n .
  else
    smerge -n "$@"
  fi
}

# -----------------------------------------------------------------------------
# python
alias p='python3'
alias p2='python2'
alias pp='python3 -m ptpython || ptpython'
alias pp-install='pip3 install ptpython'
alias jn='jupyter notebook'

# -----------------------------------------------------------------------------
# k8s
alias k='kubectl'

# -----------------------------------------------------------------------------
# markdown
make-markdown() {
  marked "$1" -o "${1%.*}".html --gfm && echo '<style>body { font: 16px sans-serif; width: 720px; margin: 1em auto; } img { width: 100%; }</style>' >> "${1%.*}".html
}

watch-markdown() {
  fswatch "$1" | while read; do make-markdown "$1" ; done
}

# -----------------------------------------------------------------------------
# plantuml
plantuml-server() {
  docker run -d --name plantuml --restart always -p 18080:8080 plantuml/plantuml-server:jetty
}

make-plantuml-slow() {
  plantuml -tpng "$1"
}

make-plantuml() {
  curl -sS "http://localhost:18080/png/`cat "$1" | gzip -c | tail -c +11 | base64 | tr ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/+ 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_- | tr -d '\n'`" > "${1%.*}".png
}

watch-plantuml-slow() {
  fswatch "$1" | while read; do make-plantuml-slow "$1" ; done
}

watch-plantuml() {
  fswatch "$1" | while read; do make-plantuml "$1" ; done
}

# -----------------------------------------------------------------------------
# mermaid
make-mermaid() {
  mmdc -i "$1" -o "${1%.*}".png
}

watch-mermaid() {
  fswatch "$1" | while read; do make-mermaid "$1" ; done
}
