# vim: ft=zsh

# =============================================================================
# env
export PATH="$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

can-exec() {
  (( $+commands[$1] ))
}

if uname -a | grep Darwin > /dev/null; then
  export IS_MACOS=1
else
  export IS_MACOS=0
fi

if can-exec brew; then
  eval "$(brew shellenv)"
fi

if can-exec nvim; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi


# =============================================================================
# plugins
source "$HOME/.antidote/antidote.zsh"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true

antidote load

autoload -Uz promptinit && promptinit && prompt pure
compstyle prezto
export PATH="$(antidote path reo7sp/zimfw-git)/functions:$PATH"


# =============================================================================
# zsh config

# -----------------------------------------------------------------------------
# colors
export CLICOLOR=true
export LSCOLORS='exfxcxdxbxegedabagacad'

# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# glob
unsetopt nomatch

# -----------------------------------------------------------------------------
# keybinds
WORDCHARS=${WORDCHARS/\/}
WORDCHARS=${WORDCHARS/_}
WORDCHARS=${WORDCHARS/|}
WORDCHARS=${WORDCHARS/-}
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete # shift-tab
function my_bindkeys() {
  bindkey '^B' backward-word
  bindkey '^F' forward-word
}
zvm_after_init_commands+=(my_bindkeys)


# =============================================================================
# aliases & settings

# -----------------------------------------------------------------------------
# general
alias le='less'

alias w='which'
alias h='history'

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

alias rm='rm -f'
alias cp='cp -f'
alias mv='mv -f'

alias suz='su -m -c zsh'
alias sudoz="sudo ZDOTDIR=\$HOME PATH=\$PATH zsh"

if [[ $IS_MACOS -eq 1 ]]; then
  alias show-ports='lsof -iTCP -sTCP:LISTEN -n -P'
else
  alias show-ports='netstat -tulpn'
fi

alias edit-hosts='sudo vim /etc/hosts'
alias show-hosts='cat /etc/hosts'

aliases-ls() {
  cat $(antidote path zimfw/exa)/init.zsh
}

# -----------------------------------------------------------------------------
# vim
if can-exec nvim; then
  vim() {
    lcd
    nvim "$@"
  }
else
  if [[ -z $real_vim ]]; then
    real_vim=$(which vim)
  fi
  vim() {
    lcd
    $real_vim "$@"
  }
fi

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
alias edit-zsh-plugins='vim ~/.zsh_plugins.txt; source ~/.zshrc'
alias edit-zshrc='vim ~/.zshrc; source ~/.zshrc'

# -----------------------------------------------------------------------------
# kitty
alias edit-kitty="vim ~/.config/kitty/kitty.conf"

# -----------------------------------------------------------------------------
# ssh
if [[ $TERM == 'xterm-kitty' ]]; then
  alias ssh='TERM=xterm-256color ssh'
fi

alias edit-ssh='vim ~/.ssh/config'
alias copy-ssh='cat ~/.ssh/id_rsa.pub | pbcopy'
alias show-ssh='cat ~/.ssh/config'

# -----------------------------------------------------------------------------
# tmux
tm() {
  tmux -2 a || tmux -2 new
}

# -----------------------------------------------------------------------------
# git
alias gg='lazygit'
alias gll='tig'

gwdn() {
  gwd --name-only "$@"
}

gwde() {
  gwd --ext-diff "$@"
}

gcsn() {
  gcs --name-only "$@"
}

gcse() {
  gcs --ext-diff "$@"
}

alias gcss='git rev-parse HEAD'

alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

gfcd() {
  local repo=$1
  local dir=$2

  if [[ -z "$dir" ]]; then
    dir=${repo##*/}
    dir=${dir%.git}
  fi

  git clone "$repo" "$dir"
  cd "$dir"
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

aliases-git() {
  cat $(antidote path reo7sp/zimfw-git)/init.zsh
}

# -----------------------------------------------------------------------------
# difft
export DFT_CONTEXT=10
export DFT_DISPLAY=side-by-side-show-both
export DFT_PARSE_ERROR_LIMIT=9999

# -----------------------------------------------------------------------------
# rg
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

alias edit-rg="vim $RIPGREP_CONFIG_PATH"

# -----------------------------------------------------------------------------
# fd
export FD_BIN=fd

if can-exec fdfind; then
  export FD_BIN=fdfind

  fd() {
    $FD_BIN "$@"
  }
fi

# -----------------------------------------------------------------------------
# fzf
if can-exec fzf; then
  zvm_after_init_commands+=('source <(fzf --zsh 2>/dev/null)')
fi

if can-exec fd; then
  export FZF_DEFAULT_COMMAND="$FD_BIN --type f --strip-cwd-prefix"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

alias f='fzf'

catf() {
  fzf --bind 'enter:become(cat {})'
}

batf() {
  fzf --bind 'enter:become(bat {})'
}

lessf() {
  fzf --bind 'enter:become(less {})'
}

vimf() {
  lcd
  fzf --bind "enter:become($EDITOR {})"
}

tf() {
  lcd
  fzf --bind 'enter:become(subl {})'
}

cdf() {
  cd $(find . -depth 5 -type d -not -path '*/\.*' -print 2> /dev/null | fzf)
}

cdfm() {
  cd $(find .          -type d -not -path '*/\.*' -print 2> /dev/null | fzf)
}

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
# go
export GOTESTSUM_FORMAT=testdox

# -----------------------------------------------------------------------------
# python
if can-exec python3 && ! can-exec python; then
  python() {
    python3 "$@"
  }
fi

if can-exec pyenv; then
  lazyload pyenv -- 'eval "$(pyenv init -)"'
fi

alias p='python3'
alias p2='python2'
alias pp='python3 -m ptpython || ptpython'
alias pp-install='pip3 install ptpython'
alias jn='jupyter notebook'

# -----------------------------------------------------------------------------
# docker
export DOCKER_BUILDKIT=1

alias d='docker'
alias dc='docker-compose'

# -----------------------------------------------------------------------------
# k8s
alias k='kubectl'

# -----------------------------------------------------------------------------
# utils
random-string() {
  local arg=$1
  openssl rand -hex "$((arg / 2))"
}

alias timestamp='date +%s'

alias is-ip-in-net='python3 -c "import sys; from ipaddress import ip_address, ip_network; print(ip_address(sys.argv[1]) in ip_network(sys.argv[2]))"'

# -----------------------------------------------------------------------------
# encode / decode
alias encode-url='python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))"'
alias decode-url='python3 -c "import sys, urllib.parse; print(urllib.parse.unquote_plus(sys.stdin.read().strip()))"'

alias encode-html='python3 -c "import sys, html; print(html.escape(sys.stdin.read().strip()))"'
alias decode-html='python3 -c "import sys, html; print(html.unescape(sys.stdin.read().strip()))"'

alias encode-base64='python3 -c "import sys, base64; sys.stdout.buffer.write(base64.b64encode(sys.stdin.buffer.read()))"'
alias decode-base64='python3 -c "import sys, base64; sys.stdout.buffer.write(base64.b64decode(sys.stdin.read().strip()))"'

# -----------------------------------------------------------------------------
# flags
alias decode-flags-bin="python3 -c \"print([f'(1 << {i})' for i, v in enumerate(bin(int(input()))[2:][::-1]) if v == '1'])\""
alias decode-flags-hex="python3 -c \"print([hex(1 << i) for i, v in enumerate(bin(int(input()))[2:][::-1]) if v == '1'])\""

# -----------------------------------------------------------------------------
# markdown
make-markdown() {
  marked "$1" -o "${1%.*}".html --gfm && echo '<style>body { font: 16px sans-serif; width: 720px; margin: 1em auto; } img { width: 100%; }</style>' >> "${1%.*}".html
}

watch-markdown() {
  make-markdown "$1"
  open "${1%.*}".html
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
  make-plantuml-slow "$1"
  open "${1%.*}".png
  fswatch "$1" | while read; do make-plantuml-slow "$1" ; done
}

watch-plantuml() {
  make-plantuml "$1"
  open "${1%.*}".png
  fswatch "$1" | while read; do make-plantuml "$1" ; done
}

# -----------------------------------------------------------------------------
# mermaid
make-mermaid() {
  mmdc -i "$1" -o "${1%.*}".png
}

watch-mermaid() {
  make-mermaid "$1"
  open "${1%.*}".png
  fswatch "$1" | while read; do make-mermaid "$1" ; done
}
