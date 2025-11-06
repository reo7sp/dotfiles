# vim: ft=zsh

# =============================================================================
# env
export PATH="$HOME/bin:$HOME/.local/bin:$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if [[ -n $SSH_CLIENT || -n $SSH_TTY || -n $SSH_CONNECTION ]]; then
  export IS_SSH=1
else
  export IS_SSH=0
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  if [[ $IS_SSH == 0 && $TERM == 'xterm-kitty' ]]; then
    echo -ne '\e[6 q'   # cursor beam
    echo -ne '\e]2;~\a' # title "~"
  fi
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if uname -a | grep Darwin > /dev/null; then
  export IS_MACOS=1
else
  export IS_MACOS=0
fi

can-exec() {
  (( $+commands[$1] ))
}

if can-exec brew; then
  eval "$(brew shellenv)"
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

if can-exec nvim; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi


# =============================================================================
# plugins
source "$HOME/.antidote/antidote.zsh"

antidote load


# =============================================================================
# plugins settings

# -----------------------------------------------------------------------------
# romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
typeset -g POWERLEVEL9K_ASDF_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_GOENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_NODENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_NVM_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_RBENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_LUAENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_JENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_PLENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_PHPENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_SCALAENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_PYENV_SOURCES=(shell)
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=true
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true

# -----------------------------------------------------------------------------
# jeffreytse/zsh-vi-mode
function my-zvm-init() {
  bindkey -M vicmd '^[' undefined-key
}
zvm_after_init_commands+=(my-zvm-init)

# -----------------------------------------------------------------------------
# mdumitru/fancy-ctrl-z
function fancy-ctrl-z-with-zvm() {
  fancy-ctrl-z
  zvm_enter_insert_mode
}
function fancy-ctrl-z-with-zvm-init() {
  zvm_define_widget fancy-ctrl-z-with-zvm
  zvm_bindkey viins '^Z' fancy-ctrl-z-with-zvm
  zvm_bindkey vicmd '^Z' fancy-ctrl-z-with-zvm
}
zvm_after_init_commands+=(fancy-ctrl-z-with-zvm-init)

# -----------------------------------------------------------------------------
# zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

function zsh-autosuggestions-init() {
  bindkey '^ ' autosuggest-accept
}
zvm_after_init_commands+=(zsh-autosuggestions-init)

# -----------------------------------------------------------------------------
# zsh-users/zsh-history-substring-search
export HISTORY_SUBSTRING_SEARCH_PREFIXED=1

function zsh-history-substring-search-init() {
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^P' history-substring-search-up
  bindkey '^N' history-substring-search-down
}
zvm_after_init_commands+=(zsh-history-substring-search-init)

# -----------------------------------------------------------------------------
# zimfw/git
export PATH="$(antidote path reo7sp/zimfw-git)/functions:$PATH"

# -----------------------------------------------------------------------------
# junegunn/fzf-git.sh
function fzf-git-bindkeys() {
  zvm_bindkey viins "^P" up-line-or-beginning-search
  zvm_bindkey viins "^N" down-line-or-beginning-search
  for o in files branches tags remotes hashes stashes lreflogs each_ref; do
    eval "zvm_bindkey viins '^g^${o[1]}' fzf-git-$o-widget"
    eval "zvm_bindkey viins '^g${o[1]}' fzf-git-$o-widget"
  done
}
function fzf-git-lazy-bindkeys() {
  for o in files branches tags remotes hashes stashes lreflogs each_ref; do
    eval "zvm_bindkey vicmd '^g^${o[1]}' fzf-git-$o-widget"
    eval "zvm_bindkey vicmd '^g${o[1]}' fzf-git-$o-widget"
    eval "zvm_bindkey visual '^g^${o[1]}' fzf-git-$o-widget"
    eval "zvm_bindkey visual '^g${o[1]}' fzf-git-$o-widget"
  done
}
zvm_after_init_commands+=(fzf-git-bindkeys)
zvm_after_init_commands+=(fzf-git-lazy-bindkeys)

# -----------------------------------------------------------------------------
# belak/zsh-utils path:completion
compstyle prezto


# =============================================================================
# zsh settings

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

function my-bindkeys() {
  bindkey '^B' backward-word
  bindkey '^F' forward-word
}
zvm_after_init_commands+=(my-bindkeys)


# =============================================================================
# aliases & settings

# -----------------------------------------------------------------------------
# general
alias le='less'
alias o='open'
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
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias rgrep='rgrep --color=auto'
alias zgrep='zgrep --color=auto'
alias zfgrep='zfgrep --color=auto'
alias zegrep='zegrep --color=auto'
alias bzgrep='bzgrep --color=auto'
alias bzfgrep='bzfgrep --color=auto'
alias bzegrep='bzegrep --color=auto'

if can-exec colordiff; then
  alias diff='colordiff'
fi

alias rm='rm -f'
alias cp='cp -f'
alias mv='mv -f'

alias suz='su -m -c zsh'
alias sudoz="sudo ZDOTDIR=\$HOME PATH=\$PATH zsh"

if [[ $IS_MACOS == 1 ]]; then
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
# zsh
alias edit-zsh='vim ~/.my.zshrc; source ~/.zshrc'
alias edit-zsh-plugins='vim ~/.zsh_plugins.txt; source ~/.zshrc'
alias edit-zsh-p10k='vim ~/.p10k.zsh; source ~/.zshrc'
alias edit-zshrc='vim ~/.zshrc; source ~/.zshrc'

alias autoenv-edit-enter='vim .autoenv.zsh'
alias autoenv-edit-leave='vim .autoenv_leave.zsh'

# -----------------------------------------------------------------------------
# vim
if can-exec nvim; then
  vim() {
    lcd
    nvim "$@"
  }
elif can-exec vim; then
  if [[ -z $REAL_VIM ]]; then
    export REAL_VIM=$(which vim)
  fi
  vim() {
    lcd
    $REAL_VIM "$@"
  }
fi

if can-exec v; then
  if [[ -z $REAL_V ]]; then
    export REAL_V=$(which v)
  fi
  vlang() {
    $REAL_V "$@"
  }
fi
alias v='vim'

xargs-vim() {
  vim -q -
}
alias xargs-v='xargs-vim'

alias edit-vim='vim ~/.my.vimrc'
alias edit-vimrc='vim ~/.vimrc'
alias edit-vim-minuet-llm-remote='vim ~/.config/nvim/lua/minuet_llm_remote_config.lua'

time-start-vim() {
  vim --startuptime /tmp/startuptime.log "$@" +qa
  cat /tmp/startuptime.log
}

profile-start-vim() {
  vim --cmd 'profile start /tmp/profile.log' --cmd 'profile func *' --cmd 'profile file *' -c 'profdel func *' -c 'profdel file *' "$@" -c 'qa!'
  cat /tmp/profile.log
}

enable-vim-colors-dark() {
  export VIM_COLORS_DARK=1
}

enable-vim-colors-light() {
  export VIM_COLORS_DARK=0
}

alias disable-vim-colors-dark='enable-vim-colors-light'
alias disable-vim-colors-light='enable-vim-colors-dark'

# -----------------------------------------------------------------------------
# ranger
export HIGHLIGHT_STYLE=bright

alias r='ranger'

alias edit-ranger='vim ~/.config/ranger/rc.conf'

# -----------------------------------------------------------------------------
# kitty
alias edit-kitty='vim ~/.config/kitty/kitty.conf'

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
# fd
if can-exec fdfind; then
  if [[ -z $REAL_FD ]]; then
    export REAL_FD=$(which fdfind)
  fi
elif can-exec fd; then
  if [[ -z $REAL_FD ]]; then
    export REAL_FD=$(which fd)
  fi
fi

export FD_OPTIONS='--hidden'

if [[ -n $REAL_FD ]]; then
  fd() {
    $REAL_FD $FD_OPTIONS "$@"
  }
  fdg() {
    $REAL_FD "$@"
  }
fi

# -----------------------------------------------------------------------------
# rg
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

alias edit-rg="vim $RIPGREP_CONFIG_PATH"

# -----------------------------------------------------------------------------
# zoxide
if can-exec zoxide; then
  zvm_after_init_commands+=('eval "$(zoxide init zsh)"')
fi

# -----------------------------------------------------------------------------
# fzf
export FZF_DEFAULT_OPTS='--color=light'

if can-exec fzf; then
  zvm_after_init_commands+=('source <(fzf --zsh 2>/dev/null)')
fi

if can-exec fd; then
  export FZF_DEFAULT_COMMAND="$REAL_FD $FD_OPTIONS --type f --strip-cwd-prefix"
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
alias vf='vimf'

tf() {
  lcd
  fzf --bind 'enter:become(subl {})'
}

cdf() {
  cd "$(find . -type d -not -path '*/\.*' -print 2> /dev/null | fzf)"
}

_fzf_git_fzf () {
  fzf $FZF_DEFAULT_OPTS --height 50% --tmux 90%,70% --layout reverse --multi --min-height 20+ --border --no-separator --header-border horizontal --border-label-pos 2 --color 'label:blue' --preview-window 'right,50%' --preview-border line --bind 'ctrl-/:change-preview-window(down,50%|hidden|)' "$@"
}

# -----------------------------------------------------------------------------
# git
alias gg='lazygit'
alias gll='tig'

alias gwdd='DELTA_FEATURES=+side-by-side gwd'
alias gwdt='gwd --ext-diff'
alias gwdn='gwd --name-only'
alias gwdh='gwd HEAD'
alias gwddh='gwdd HEAD'
alias gwdth='gwdt HEAD'
alias gwdnh='gwdn HEAD'
alias gcsd='DELTA_FEATURES=+side-by-side gcs'
alias gcst='gcs --ext-diff'
alias gcsn='gcs --name-only --pretty=""'
alias gcss='git rev-parse HEAD'
alias gcsj='git show --no-patch'
alias gcsc='git show --stat'

alias gcom='gco master'
alias gcomm='gco origin/master'
alias gcoh='gco HEAD'

gcoi() {
  _fzf_git_branches --no-multi | xargs git checkout
}

git-default-branch() {
  git symbolic-ref refs/remotes/origin/HEAD | cut -f4 -d/
}

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

glab-cd() {
  local repo=$1
  local dir=$2

  if [[ -z "$dir" ]]; then
    dir=${repo##*/}
    dir=${dir%.git}
  fi

  glab repo clone "$repo" "$dir"
  cd "$dir"
}

gh-cd() {
  local repo=$1
  local dir=$2

  if [[ -z "$dir" ]]; then
    dir=${repo##*/}
    dir=${dir%.git}
  fi

  gh repo clone "$repo" "$dir"
  cd "$dir"
}

alias gcu='git add -A && git commit --amend --reuse-message HEAD'

alias gc-wip="git add -A && git commit -m 'wip'"
alias gc-fix="git add -A && git commit -m 'fix'"
alias gc-upd="git add -A && git commit -m 'update'"
alias gc-kik="git add -A && git commit -m 'kik'"

alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias gbd='gb -D'

gbdr() {
  echo "$@" | xargs -n1 git branch -D
  echo "$@" | xargs -n1 -P0 git push origin --delete
}

alias gfm-all="find . -maxdepth 1 -type d | xargs -n1 -t -I{} git -C '{}' pull"
alias gfr-all="find . -maxdepth 1 -type d | xargs -n1 -t -I{} git -C '{}' pull --rebase"
alias gb-all="find . -maxdepth 1 -type d | xargs -n1 -t -I{} git -C '{}' branch"

git-fix-macos() {
  # 1) Очищаем существующие fetch правила
  echo "🔧 Очищаю существующие fetch правила..."
  git config --unset-all remote.origin.fetch 2>/dev/null || true
  git config --add remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git config --add remote.origin.fetch "+refs/tags/*:refs/tags/*"

  # 2) Получаем список удаленных ссылок
  echo "📡 Получаю список удаленных ссылок..."
  remote_heads=$(git ls-remote --heads origin)
  remote_tags=$(git ls-remote --tags --refs origin)

  # 3) Анализирую ветки
  echo "🌿 Анализирую ветки..."
  branch_dups=$(echo "$remote_heads" | awk '/refs\/heads\// {print $2}' \
    | sed 's#refs/heads/##' | awk '{print tolower($0)}' | sort | uniq -d)

  if [ -n "$branch_dups" ]; then
    count=0
    total=$(echo "$branch_dups" | wc -l)
    echo "$branch_dups" | while read -r dup; do
      count=$((count + 1))
      echo "[$count/$total] Обрабатываю конфликт имён веток: $dup"

      variants=$(echo "$remote_heads" | awk -v d="$dup" '/refs\/heads\// {
        name = $2; gsub(/refs\/heads\//, "", name);
        if (tolower(name) == d) print name
      }')

      canonical=""
      for v in ${(f)variants}; do
        if [ "$v" = "$dup" ]; then
          canonical="$v"
          break
        fi
      done
      if [ -z "$canonical" ]; then
        canonical="${variants%%$'\n'*}"
      fi

      echo "  ✅ Оставляю: $canonical"
      for v in ${(f)variants}; do
        if [ "$v" != "$canonical" ]; then
          echo "  ❌ Исключаю: $v"
          git config --add remote.origin.fetch "^refs/heads/$v"
        fi
      done
    done
  fi

  # 4) Анализирую теги
  echo "🏷️ Анализирую теги..."
  tag_dups=$(echo "$remote_tags" | awk '/refs\/tags\// {print $2}' \
    | sed 's#refs/tags/##' \
    | awk '{print tolower($0)}' | sort | uniq -d)

  if [ -n "$tag_dups" ]; then
    count=0
    total=$(echo "$tag_dups" | wc -l)
    echo "$tag_dups" | while read -r dup; do
      count=$((count + 1))
      echo "[$count/$total] Обрабатываю конфликт имён тегов: $dup"

      variants=$(echo "$remote_tags" | awk -v d="$dup" '/refs\/tags\// {
        name = $2; gsub(/refs\/tags\//, "", name);
        if (tolower(name) == d) print name
      }')

      canonical=""
      for v in ${(f)variants}; do
        if [ "$v" = "$dup" ]; then
          canonical="$v"
          break
        fi
      done
      if [ -z "$canonical" ]; then
        canonical="${variants%%$'\n'*}"
      fi

      echo "  ✅ Оставляю тег: $canonical"
      for v in ${(f)variants}; do
        if [ "$v" != "$canonical" ]; then
          echo "  ❌ Исключаю тег: $v"
          git config --add remote.origin.fetch "^refs/tags/$v"
        fi
      done
    done
  fi

  # 5) Очищаю локальные ссылки
  echo "🧹 Очищаю локальные ссылки..."
  rm -f .git/packed-refs.lock .git/refs/remotes/origin/*.lock .git/refs/tags/*.lock
  rm -rf .git/refs/remotes/origin .git/refs/tags 2>/dev/null || true
  mkdir -p .git/refs/remotes/origin .git/refs/tags

  # 6) Выполняю fetch
  echo "📥 Выполняю fetch..."
  git fetch --prune origin
}

aliases-git() {
  cat $(antidote path reo7sp/zimfw-git)/init.zsh
}

alias edit-lazygit='vim ~/Library/Application\ Support/lazygit/config.yml'
alias edit-lazygit-sh='vim ~/Library/Application\ Support/lazygit/shell.sh'

# -----------------------------------------------------------------------------
# delta
alias deltad='DELTA_FEATURES=+side-by-side delta'

# -----------------------------------------------------------------------------
# difft
export DFT_CONTEXT=10
export DFT_DISPLAY=side-by-side-show-both
export DFT_GRAPH_LIMIT=99999999
export DFT_PARSE_ERROR_LIMIT=9999

# -----------------------------------------------------------------------------
# bat
export BAT_PAGING=never

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
# codex
if can-exec codex; then
  if [[ -z $REAL_CODEX ]]; then
    export REAL_CODEX=$(which codex)
  fi
fi

if [[ -n $REAL_CODEX ]]; then
  codex() {
    ALL_PROXY=socks5h://127.0.0.1:1086 $REAL_CODEX "$@"
  }
fi

# -----------------------------------------------------------------------------
# claude
if can-exec claude; then
  if [[ -z $REAL_CLAUDE ]]; then
    export REAL_CLAUDE=$(which claude)
  fi
fi

if [[ -n $REAL_CLAUDE ]]; then
  claude() {
    ALL_PROXY=socks5h://127.0.0.1:1086 $REAL_CLAUDE "$@"
  }
fi

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
alias pp-install='pip3 install ptpython --break-system-packages'
alias jn='jupyter notebook'

# -----------------------------------------------------------------------------
# nodejs
export NVM_DIR="$HOME/.nvm"

load_nvm() {
  if [[ -z "$NVM_LOADED" ]]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    export NVM_LOADED=1
  fi
}

nvm() { load_nvm; command nvm "$@"; }
npm() { load_nvm; command npm "$@"; }
yarn() { load_nvm; command yarn "$@"; }
pnpm() { load_nvm; command pnpm "$@"; }
node() { load_nvm; command node "$@"; }
npx() { load_nvm; command npx "$@"; }

# -----------------------------------------------------------------------------
# docker
export DOCKER_BUILDKIT=1

alias d='docker'
alias dc='docker-compose'

# -----------------------------------------------------------------------------
# k8s
alias k='kubectl'

# -----------------------------------------------------------------------------
# swagger
alias open-swagger='npx open-swagger-ui --open'

# -----------------------------------------------------------------------------
# utils
random-string() {
  local arg=$1
  openssl rand -hex "$((arg / 2))"
}

alias timestamp='date +%s'

alias is-ip-in-net='python3 -c "import sys; from ipaddress import ip_address, ip_network; print(ip_address(sys.argv[1]) in ip_network(sys.argv[2]))"'

strip-whitespace() {
  gsed -i 's/[ \t]*$//' "$@"
}

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
  fswatch "$1" | while read; do make-markdown "$1"; done
}

# -----------------------------------------------------------------------------
# plantuml
plantuml-server-start() {
  docker run -d --rm --name plantuml -p 18080:8080 plantuml/plantuml-server:jetty
}

plantuml-server-stop() {
  docker stop plantuml
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
  fswatch "$1" | while read; do make-plantuml-slow "$1"; done
}

watch-plantuml() {
  make-plantuml "$1"
  open "${1%.*}".png
  fswatch "$1" | while read; do make-plantuml "$1"; done
}

plantuml-editor-start() {
  docker run -d --rm --name plantuml-editor -p 18081:8080 hakenadu/plantuml-editor
}

plantuml-editor-stop() {
  docker stop plantuml-editor
}

# -----------------------------------------------------------------------------
# mermaid
make-mermaid() {
  mmdc -i "$1" -o "${1%.*}".png
}

watch-mermaid() {
  make-mermaid "$1"
  open "${1%.*}".png
  fswatch "$1" | while read; do make-mermaid "$1"; done
}

mermaid-editor-start() {
  docker run -d --rm --name mermaid-editor -p 18082:8080 ghcr.io/mermaid-js/mermaid-live-editor
}

mermaid-editor-stop() {
  docker stop mermaid-editor
}
