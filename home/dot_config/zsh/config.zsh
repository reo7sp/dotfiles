# vim: ft=zsh

# =============================================================================
# env
export PATH="\
$HOME/.local/bin:\
$PATH:\
/Applications/Sublime Text.app/Contents/SharedSupport/bin:\
/Applications/Sublime Merge.app/Contents/SharedSupport/bin:\
/usr/local/sbin:\
/usr/local/bin:\
/usr/sbin:\
/usr/bin:\
/sbin:\
/bin"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export SHELL_SESSIONS_DISABLE=1

if [[ -n $SSH_CLIENT || -n $SSH_TTY || -n $SSH_CONNECTION ]]; then
  export IS_SSH=1
else
  export IS_SSH=0
fi

if [[ $OSTYPE == linux* && $HOST == lima-* ]]; then
  export IS_LIMA=1
else
  export IS_LIMA=0
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  if (( ! IS_SSH )) && [[ $TERM == 'xterm-kitty' ]]; then
    echo -ne '\e[5 q'   # blinking cursor beam
    echo -ne '\e]2;~\a' # title "~"
  fi
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ $OSTYPE == darwin* ]]; then
  export IS_MACOS=1
else
  export IS_MACOS=0
fi

if (( IS_MACOS )) && [[ $TERM == 'xterm-kitty' && -f "$HOME/.terminfo/78/xterm-kitty" ]]; then
  export TERMINFO="$HOME/.terminfo"
fi

can-exec() {
  (( $+commands[$1] ))
}

if [[ :$FPATH: != *:/opt/homebrew/share/zsh/site-functions:* ]] && can-exec brew; then
  eval "$(brew shellenv zsh)"
fi

if can-exec nvim; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

export DOCUMENTS_HOME="${DOCUMENTS_HOME:-$HOME/Documents}"

if (( IS_MACOS )) && can-exec macism; then
  macism com.apple.keylayout.ABC > /dev/null 2>&1 &!
fi

# =============================================================================
# plugins
fpath+=~/.zfunc
fpath+=~/.ya.completion/zsh

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('open-swagger-ui')
export NVM_COMPLETION=true

typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1

source "$HOME/.antidote/antidote.zsh"

antidote load

zmodload zsh/parameter

# Заменяем $(zle -l -L ...) и $(declare -f ...) таблицами widgets и functions, чтобы регистрировать vi-виджеты без лишних subshell, сохраняя обёртки существующих виджетов.
zvm_define_widget() {
  local widget=$1
  local func=${2:-$1}
  local original=${widgets[$widget]}

  if [[ $original == user:* ]]; then
    local rawfunc=${original#user:}
    local wrapper="zvm_${widget}-wrapper"
    local called=false
    [[ ${functions[$func]} == *'$rawfunc'* ]] && called=true
    eval "$wrapper() { zvm_widget_wrapper $rawfunc $func $called \"\$@\" }"
    func=$wrapper
  fi

  zle -N "$widget" "$func"
}

if (( ! IS_SSH && ! IS_LIMA )); then
  antidote load "${ZDOTDIR:-$HOME}/.zsh_prompt_plugins.txt"
  antidote load "${ZDOTDIR:-$HOME}/.zsh_editing_plugins.txt"
fi


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
# catppuccin/zsh-fsh
if (( ! IS_SSH && ! IS_LIMA )); then
  FSTHEME_DIR="$HOME/.config/fsh"
  if [[ ! -f "$FSTHEME_DIR/catppuccin-latte.ini" ]]; then
    mkdir -p "$FSTHEME_DIR"
    CATPPUCCIN_BUNDLE="$(antidote path catppuccin/zsh-fsh)/themes"
    ln -sf "$CATPPUCCIN_BUNDLE"/catppuccin-*.ini "$FSTHEME_DIR"/
  fi
fi

# -----------------------------------------------------------------------------
# jeffreytse/zsh-vi-mode
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE

my-zvm-init() {
  bindkey -M vicmd '^[' undefined-key
}
zvm_after_init_commands+=(my-zvm-init)

# Выбираем escape-последовательность курсора через case вместо $(zvm_cursor_style ...), чтобы избежать лишних subshell при смене vi-режима и восстановлении курсора перед запуском команды.
my-zvm-set-cursor() {
  local style=${(L)1}
  case $ZVM_TERM in
    xterm*|rxvt*|screen*|tmux*|konsole*|alacritty*|st*|foot*|wezterm)
      case $style in
        $ZVM_CURSOR_BLOCK) style='\e[2 q';;
        $ZVM_CURSOR_UNDERLINE) style='\e[4 q';;
        $ZVM_CURSOR_BEAM) style='\e[6 q';;
        $ZVM_CURSOR_BLINKING_BLOCK) style='\e[1 q';;
        $ZVM_CURSOR_BLINKING_UNDERLINE) style='\e[3 q';;
        $ZVM_CURSOR_BLINKING_BEAM) style='\e[5 q';;
        $ZVM_CURSOR_USER_DEFAULT) style='\e[0 q';;
      esac
      ;;
    *) style='\e[0 q';;
  esac
  if [[ $style == '\e[0 q' ]]; then
    local old_style
    case $ZVM_MODE in
      $ZVM_MODE_INSERT) old_style=$ZVM_INSERT_MODE_CURSOR;;
      $ZVM_MODE_NORMAL) old_style=$ZVM_NORMAL_MODE_CURSOR;;
      $ZVM_MODE_VISUAL) old_style=$ZVM_VISUAL_MODE_CURSOR;;
      $ZVM_MODE_VISUAL_LINE) old_style=$ZVM_VISUAL_LINE_MODE_CURSOR;;
    esac
    [[ $old_style =~ '\e\][0-9]+;.+\a' ]] && style+='\e\e]112\a'
  fi
  zvm_set_cursor "$style"
}

zvm_update_cursor() {
  $ZVM_CURSOR_STYLE_ENABLED || return
  if $ZVM_OPPEND_MODE; then
    my-zvm-set-cursor "$ZVM_OPPEND_MODE_CURSOR"
    return
  fi
  case ${1:-$ZVM_MODE} in
    $ZVM_MODE_NORMAL) my-zvm-set-cursor "$ZVM_NORMAL_MODE_CURSOR";;
    $ZVM_MODE_INSERT) my-zvm-set-cursor "$ZVM_INSERT_MODE_CURSOR";;
    $ZVM_MODE_VISUAL) my-zvm-set-cursor "$ZVM_VISUAL_MODE_CURSOR";;
    $ZVM_MODE_VISUAL_LINE) my-zvm-set-cursor "$ZVM_VISUAL_LINE_MODE_CURSOR";;
  esac
}

zvm_zle-line-finish() {
  my-zvm-set-cursor "$ZVM_CURSOR_USER_DEFAULT"
  zvm_switch_keyword_history=()
}

# -----------------------------------------------------------------------------
# mdumitru/fancy-ctrl-z
fancy-ctrl-z-with-zvm() {
  fancy-ctrl-z
  zvm_enter_insert_mode
}
fancy-ctrl-z-with-zvm-init() {
  zvm_define_widget fancy-ctrl-z-with-zvm
  zvm_bindkey viins '^Z' fancy-ctrl-z-with-zvm
  zvm_bindkey vicmd '^Z' fancy-ctrl-z-with-zvm
}
zvm_after_init_commands+=(fancy-ctrl-z-with-zvm-init)

# -----------------------------------------------------------------------------
# zsh-users/zsh-autosuggestions
if (( ! IS_SSH && ! IS_LIMA )); then
  export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

  zsh-autosuggestions-init() {
    bindkey '^ ' autosuggest-accept
    zsh-defer _zsh_autosuggest_bind_widgets
  }
  zvm_after_init_commands+=(zsh-autosuggestions-init)
  zvm_after_lazy_keybindings_commands+=('zsh-defer _zsh_autosuggest_bind_widgets')
fi

# -----------------------------------------------------------------------------
# zsh-users/zsh-history-substring-search
export HISTORY_SUBSTRING_SEARCH_PREFIXED=1

zsh-history-substring-search-init() {
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
fzf-git-bindkeys() {
  autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
  zle -N up-line-or-beginning-search
  zle -N down-line-or-beginning-search
  zvm_bindkey viins "^P" up-line-or-beginning-search
  zvm_bindkey viins "^N" down-line-or-beginning-search
  for o in files branches tags remotes hashes stashes lreflogs each_ref; do
    eval "zvm_bindkey viins '^g^${o[1]}' fzf-git-$o-widget"
    eval "zvm_bindkey viins '^g${o[1]}' fzf-git-$o-widget"
  done
}
fzf-git-lazy-bindkeys() {
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
WORDCHARS=${WORDCHARS/=}
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete # shift-tab

my-bindkeys() {
  bindkey '^B' backward-char
  bindkey '^F' forward-char
  bindkey '^[b' backward-word
  bindkey '^[f' forward-word
  bindkey '^A' beginning-of-line
  bindkey '^E' end-of-line
}
zvm_after_init_commands+=(my-bindkeys)

if (( IS_MACOS )) && can-exec macism; then
  ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(.zsh-focus-in .zsh-focus-out)

  zsh-focus-tracking-enable() {
    printf '\e[?1004h'
  }

  zsh-focus-tracking-disable() {
    printf '\e[?1004l'
  }

  zsh-focus-in() {
    macism com.apple.keylayout.ABC > /dev/null 2>&1 &!
  }

  zsh-focus-out() {
    return 0
  }

  zsh-focus-events-init() {
    zle -N .zsh-focus-in zsh-focus-in
    zle -N .zsh-focus-out zsh-focus-out
    local keymap
    for keymap in viins vicmd visual viopp isearch command menuselect; do
      bindkey -M "$keymap" $'\e[I' .zsh-focus-in
      bindkey -M "$keymap" $'\e[O' .zsh-focus-out
    done

    autoload -Uz add-zsh-hook
    add-zsh-hook precmd zsh-focus-tracking-enable
    add-zsh-hook precmd zsh-focus-in
    add-zsh-hook preexec zsh-focus-tracking-disable
    zsh-focus-tracking-enable
  }
  zvm_after_init_commands+=(zsh-focus-events-init)
fi


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
  mkcd "$DOCUMENTS_HOME/oneoff-code/$(date '+%Y-%m-%d')"
}

clear-empty-tmps() {
  local tmp_root="$DOCUMENTS_HOME/oneoff-code"
  [[ -d "$tmp_root" ]] || return 0

  find "$tmp_root" -mindepth 1 -maxdepth 1 -type d -empty -exec rmdir {} +
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

if (( IS_MACOS )); then
  alias show-ports='lsof -iTCP -sTCP:LISTEN -n -P'
else
  alias show-ports='netstat -tulpn'
fi

alias edit-hosts='sudo vim /etc/hosts'

aliases-ls() {
  cat $(antidote path zimfw/exa)/init.zsh
}

# -----------------------------------------------------------------------------
# zsh
alias edit-autoenv-enter='vim .autoenv.zsh'
alias edit-autoenv-leave='vim .autoenv_leave.zsh'

if can-exec direnv; then
  eval "$(direnv hook zsh)"
  functions[_my-direnv-hook]=$functions[_direnv_hook]

  # Пропускаем direnv export, если нет активного окружения и файлов .envrc/.env в текущем и родительских каталогах; иначе вызываем исходный hook для загрузки, обновления или выгрузки окружения.
  _direnv_hook() {
    if [[ -z ${DIRENV_DIR-}${DIRENV_FILE-}${DIRENV_DIFF-} ]]; then
      local directory=$PWD
      while [[ ! -e $directory/.envrc && ! -L $directory/.envrc && ! -e $directory/.env && ! -L $directory/.env ]]; do
        [[ $directory == / ]] && return 0
        directory=${directory:h}
      done
    fi
    _my-direnv-hook "$@"
  }
fi

alias edit-direnv='vim .envrc'
alias edit-envrc='vim .envrc'
alias direnv-edit='vim .envrc'
alias envrc-edit='vim .envrc'

alias edit-zsh='vim ~/.config/zsh/config.zsh; source ~/.zshrc'
alias edit-zsh-plugins='vim ~/.zsh_plugins.txt; source ~/.zshrc'
alias edit-zsh-p10k='vim ~/.p10k.zsh; source ~/.zshrc'
alias edit-zshrc='vim ~/.zshrc; source ~/.zshrc'

bak-edit() {
  local result=0
  bak-edit-zshrc "$@" || result=$?
  bak-edit-vim-custom "$@" || result=$?
  return "$result"
}

bak-edit-zshrc() {
  if [[ -f "$HOME/.zshrc.bak" ]]; then
    cp "$HOME/.zshrc.bak" "$HOME/.zshrc.bak.2" || return
  fi
  cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
}

rsync-edit-zshrc() {
  rsync -a ~/.zshrc "$1":~/.zshrc
}

upgrade-edit-zsh() {
  antidote update
}

edit-zsh-clear-cache-completion() {
  rm -rf \
    "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache" \
    "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compdump" \
    "${ZDOTDIR:-$HOME}/.zcompcache" \
    "${ZDOTDIR:-$HOME}/.zcompdump"
  exec zsh
}

# -----------------------------------------------------------------------------
# vim
if can-exec nvim; then
  vim() {
    lcd
    nvim "$@"
  }
elif can-exec vim; then
  if [[ -z $REAL_VIM ]]; then
    export REAL_VIM=${commands[vim]}
  fi
  vim() {
    lcd
    $REAL_VIM "$@"
  }
fi

if can-exec v; then
  if [[ -z $REAL_V ]]; then
    export REAL_V=${commands[v]}
  fi
  vlang() {
    $REAL_V "$@"
  }
fi
alias v='vim'

alias vdiff='vimdiff'

xargs-vim() {
  vim -q -
}
alias xargs-v='xargs-vim'

alias edit-vim='vim ~/.config/nvim/init.lua'
alias edit-vim-plugins='vim ~/.config/nvim/lua/plugins/'
alias edit-vim-commands='vim ~/.config/nvim/lua/commands.lua'
alias edit-vim-settings='vim ~/.config/nvim/lua/settings.lua'
alias edit-vim-custom-plugins='vim ~/.config/nvim/lua/plugins/custom.lua'
alias edit-vim-custom-commands='vim ~/.config/nvim/lua/commands/custom.lua'
alias edit-vim-custom-gopls='vim ~/.config/nvim/bin/custom-gopls'

alias cd-edit-vim='cd ~/.config/nvim/'

bak-edit-vim-custom() {
  local file
  for file in \
    "$HOME/.config/nvim/lua/plugins/custom.lua" \
    "$HOME/.config/nvim/lua/commands/custom.lua" \
    "$HOME/.config/nvim/bin/custom-gopls"; do
    if [[ -f "$file.bak" ]]; then
      cp "$file.bak" "$file.bak.2" || return
    fi
    cp "$file" "$file.bak" || return
  done
}

rsync-edit-vim-custom() {
  local file
  for file in \
    lua/plugins/custom.lua \
    lua/commands/custom.lua \
    bin/custom-gopls; do
    rsync -a "$HOME/.config/nvim/$file" "$1":~/.config/nvim/"$file" || return
  done
}

upgrade-edit-vim() {
  NVIM_SKIP_CUSTOM_PLUGINS=1 nvim --headless "+Lazy! sync" +qa || return
  nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll' || return
  nvim --headless "+lua assert(require('nvim-treesitter').update():wait(300000))" +qa || return
  chezmoi re-add "$HOME/.config/nvim/lazy-lock.json" || return
  NVIM_SKIP_INSTALL_PLUGINS=1 chezmoi apply "$HOME/.chezmoiscripts/nvim/install_plugins.sh" || return
}

time-start-vim() {
  vim --startuptime /tmp/startuptime.log "$@" +qa
  cat /tmp/startuptime.log
}

profile-start-vim() {
  vim --cmd 'profile start /tmp/profile.log' --cmd 'profile func *' --cmd 'profile file *' -c 'profdel func *' -c 'profdel file *' "$@" -c 'qa!'
  cat /tmp/profile.log
}

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
alias edit-tmux='vim ~/.tmux.conf'

# -----------------------------------------------------------------------------
# ssh
if [[ $TERM == 'xterm-kitty' ]]; then
  alias ssh='TERM=xterm-256color ssh'
fi

alias edit-ssh='vim ~/.ssh/config'

copy-ssh() {
  local public_key="$HOME/.ssh/id_rsa.pub"
  if [[ ! -f "$public_key" ]]; then
    echo "Missing $public_key" >&2
    return 1
  fi

  if can-exec pbcopy; then
    pbcopy < "$public_key"
  elif can-exec wl-copy; then
    wl-copy < "$public_key"
  elif can-exec xclip; then
    xclip -selection clipboard < "$public_key"
  else
    echo "No clipboard command found (pbcopy, wl-copy, or xclip)" >&2
    return 1
  fi
}

# -----------------------------------------------------------------------------
# lima
export LIMA_INSTANCE="ubuntu"
export LIMA_WORKDIR="/home/${USER}.guest"

# -----------------------------------------------------------------------------
# rg
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

alias edit-rg="vim $RIPGREP_CONFIG_PATH"

# -----------------------------------------------------------------------------
# fd
if [[ -z $REAL_FD ]]; then
  if can-exec fdfind; then
    export REAL_FD=${commands[fdfind]}
  else
    export REAL_FD=${commands[fd]}
  fi
fi

export FD_OPTIONS='--no-require-git'

fd() {
  "$REAL_FD" $FD_OPTIONS "$@"
}

# -----------------------------------------------------------------------------
# zoxide
if can-exec zoxide; then
  zvm_after_init_commands+=('eval "$(zoxide init zsh)"')
fi

alias zr='zoxide remove "$PWD"'
alias ze='zoxide edit'

# -----------------------------------------------------------------------------
# fzf
export FZF_DEFAULT_OPTS='--color=light'
export FZF_DEFAULT_COMMAND="$REAL_FD $FD_OPTIONS --type f --strip-cwd-prefix"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if can-exec fzf; then
  zvm_after_init_commands+=('source <(fzf --zsh 2>/dev/null)')
fi

alias f='fzf'

_fzf_open() {
  local selected
  selected=$(fzf) || return
  [[ -n $selected ]] || return
  "$@" "$selected"
}

catf() {
  _fzf_open cat
}

batf() {
  _fzf_open bat
}

lessf() {
  _fzf_open less
}

vimf() {
  lcd
  _fzf_open "$EDITOR"
}
alias vf='vimf'

tf() {
  lcd
  _fzf_open subl
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

alias gbd='gb -D'
gbdr() {
  echo "$@" | xargs -n1 git branch -D
  echo "$@" | xargs -n1 -P0 git push origin --delete
}
alias gb-all="find . -maxdepth 1 -type d | xargs -n1 -t -I{} git -C '{}' branch"

alias gcom='gco master'
alias gcomm='gco origin/master'
alias gcoh='gco HEAD'
gcoi() {
  _fzf_git_branches --no-multi | xargs git checkout
}
gcsd() {
  gcs "$@" | delta --side-by-side
}
alias gcst='gcs --ext-diff'
alias gcsn='gcs --name-only --pretty=""'
alias gcss='git rev-parse HEAD'
alias gcsj='git show --no-patch'
alias gcsk='git show --stat'
alias gcu='git add -A && git commit --amend --reuse-message HEAD'
alias gc-wip="git add -A && git commit -m 'wip'"
alias gc-fix="git add -A && git commit -m 'fix'"
alias gc-upd="git add -A && git commit -m 'update'"
alias gc-kik="git add -A && git commit -m 'kik'"
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
alias gfm-all='find . -maxdepth 1 -type d ! -name . | sort -R | while read -r d; do echo "$d:"; git -C "$d" pull; sleep 2; done'
alias gfr-all='find . -maxdepth 1 -type d ! -name . | sort -R | while read -r d; do echo "$d:"; git -C "$d" pull --rebase; sleep 2; done'

alias giaa='git add -A :/'

alias gww='gws'
gwdd() {
  gwd "$@" | delta --side-by-side
}
alias gwdt='gwd --ext-diff'
alias gwdn='gwd --name-only'
alias gwdh='gwd HEAD'
gwddh() {
  gwd HEAD "$@" | delta --side-by-side
}
alias gwdth='gwdt HEAD'
alias gwdnh='gwdn HEAD'

git-default-branch() {
  git symbolic-ref refs/remotes/origin/HEAD | cut -f4 -d/
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

alias edit-git-config='vim ~/.gitconfig'
alias edit-git-ignore='vim ~/.gitignore_global'
alias edit-lazygit='vim ~/.config/lazygit/config.yml'
alias edit-lazygit-sh='vim ~/.config/lazygit/shell.sh'

# -----------------------------------------------------------------------------
# arc
alias ab='arc branch'
alias abc='arc checkout -b'
alias abd='arc branch -d'
alias abdf='arc branch -D'
alias abdm='arc branch -d --merged'
alias abl='arc branch -v'

alias ac='arc commit'
alias aca='arc commit --all'
alias acm='arc commit --message'
alias aco='arc checkout'
alias acom='arc checkout trunk'
alias acf='arc commit --amend --no-edit'
alias acF='arc commit --amend'
alias acp='arc cherry-pick'
alias acpa='arc cherry-pick --abort'
alias acpc='arc cherry-pick --continue'
alias acr='arc revert'
acs() {
  arc show --git "$@" | delta
}
acsc() {
  arc show --git "$@" | _arc_filter_diff_without_tests | delta
}
acsd() {
  arc show --git "$@" | delta --side-by-side
}
acsdc() {
  arc show --git "$@" | _arc_filter_diff_without_tests | delta --side-by-side
}
acst() {
  local commit="${1:-HEAD}"
  (( $# )) && shift
  arc difftool -t difft "${commit}^" "$commit" "$@"
}
acstc() {
  local commit="${1:-HEAD}" names file
  local -a files
  (( $# )) && shift
  names=$(arc diff --git --name-only --relative=. "${commit}^" "$commit" "$@") || return
  for file in "${(@f)names}"; do
    file="${(Q)file}"
    [[ -n "$file" && "${file:t}" != test_* ]] && files+=("$PWD/$file")
  done
  (( ${#files} )) || return 0
  arc difftool -t difft "${commit}^" "$commit" "${files[@]}"
}
alias acsn='arc show --git --name-only'
alias acss='arc rev-parse HEAD'
acsj() {
  arc show --git --quiet "$@" | delta
}
acsk() {
  arc show --git --stat "$@" | delta
}
alias acu='arc add -A && arc commit --amend --no-edit'
alias ac-wip="arc add -A && arc commit -m 'wip'"
alias ac-fix="arc add -A && arc commit -m 'fix'"
alias ac-upd="arc add -A && arc commit -m 'update'"
alias ac-kik="arc add -A && arc commit -m 'kik'"

alias ad='arc ls-files'
alias adc='arc ls-files --cached'
alias adm='arc ls-files --modified'
alias adu='arc ls-files --other'

alias af='arc fetch'
alias afm='arc pull --ff-only'
alias afmm='arc pull --ff-only trunk'
alias afM='arc pull'
alias afr='arc pull --rebase'

alias aia='arc add'
alias aiaa='arc add "$(arc root)/"'
alias air='arc reset'

alias al='arc log'
ald() {
  arc log --patch "$@" | delta --side-by-side
}
alias alo='arc log --oneline'
alias alr='arc reflog'

alias ap='arc push'
alias apf='arc push --force'
alias apr='arc pr'
alias aprc='arc pr create'
alias aprco='arc pr checkout'
alias aprl='arc pr list'
alias aprr='arc pr status'
alias aprs='arc pr view'
alias aprp='arc pr publish'

alias ar='arc rebase'
alias ara='arc rebase --abort'
alias arC='arc rebase --continue'
alias ari='arc rebase --interactive'
alias ars='arc rebase --skip'
alias arm='arc rebase trunk'

alias as='arc stash'
alias asa='arc stash apply'
alias asx='arc stash drop'
alias asl='arc stash list'
alias asp='arc stash pop'
alias ass='arc stash push --include-untracked'
alias asu='arc submit'

alias aww='arc status --short'
awwc() {
  arc status --short "$@" | _arc_filter_status_without_tests
}
alias awS='arc status'
awd() {
  arc diff --git "$@" | delta
}
awdc() {
  arc diff --git "$@" | _arc_filter_diff_without_tests | delta
}
awdd() {
  arc diff --git "$@" | delta --side-by-side
}
awddc() {
  arc diff --git "$@" | _arc_filter_diff_without_tests | delta --side-by-side
}
alias awdt='arc difftool -t difft'
alias awdn='arc diff --git --name-only'
awdnc() {
  arc diff --git --name-only "$@" | _arc_filter_names_without_tests
}
awdh() {
  arc diff --git HEAD "$@" | delta
}
awdhc() {
  arc diff --git HEAD "$@" | _arc_filter_diff_without_tests | delta
}
awddh() {
  arc diff --git HEAD "$@" | delta --side-by-side
}
awddhc() {
  arc diff --git HEAD "$@" | _arc_filter_diff_without_tests | delta --side-by-side
}
awdch() {
  arc diff --git --cached HEAD "$@" | delta
}
awdchc() {
  arc diff --git --cached HEAD "$@" | _arc_filter_diff_without_tests | delta
}
alias awdnh='arc diff --git --name-only HEAD'
awdnhc() {
  arc diff --git --name-only HEAD "$@" | _arc_filter_names_without_tests
}
alias awr='arc reset'
alias awR='arc reset --hard'
alias awc='arc clean --dry-run'
alias awC='arc clean -d'
alias awm='arc mv'
alias awx='arc rm'

_arc_filter_status_without_tests() {
  local line status_path old_file new_file

  while IFS= read -r line; do
    status_path="${line[4,-1]}"
    old_file="${(Q)${status_path%% -> *}}"
    new_file="${(Q)${status_path##* -> }}"
    if [[ "${old_file:t}" != test_* && "${new_file:t}" != test_* ]]; then
      print -r -- "$line"
    fi
  done
}
_arc_filter_diff_without_tests() {
  local -a header_parts
  local block line old_file new_file
  local skip=0

  while IFS= read -r line; do
    if [[ "$line" == "diff --git "* ]]; then
      (( skip )) || print -rn -- "$block"
      block=
      skip=0
      header_parts=("${(z)line}")
      old_file="${(Q)header_parts[3]}"
      new_file="${(Q)header_parts[4]}"
      if [[ "${old_file:t}" == test_* || "${new_file:t}" == test_* ]]; then
        skip=1
      fi
    fi
    block+="$line"$'\n'
  done
  (( skip )) || print -rn -- "$block"
}
_arc_filter_names_without_tests() {
  local file

  while IFS= read -r file; do
    [[ "${file:t}" == test_* ]] || print -r -- "$file"
  done
}

cda() {
  cd "$(arc root 2>/dev/null || printf "%s\n" "$HOME/arcadia")/$1"
}

cata() {
  cat "$(arc root 2>/dev/null || printf "%s\n" "$HOME/arcadia")/$1"
}

bata() {
  bat "$(arc root 2>/dev/null || printf "%s\n" "$HOME/arcadia")/$1"
}

lessa() {
  less "$(arc root 2>/dev/null || printf "%s\n" "$HOME/arcadia")/$1"
}

vima() {
  vim "$(arc root 2>/dev/null || printf "%s\n" "$HOME/arcadia")/$1"
}
alias va='vima'

ta() {
  subl "$(arc root 2>/dev/null || printf "%s\n" "$HOME/arcadia")/$1"
}

alias yg='ya grep'
alias ygr='ya grep --remote'

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
# tree
alias tree='tree --dirsfirst'

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
if can-exec codex && [[ "${NO_PROXY_CODEX:-0}" != '1' ]]; then
  if [[ -z $REAL_CODEX ]]; then
    export REAL_CODEX=${commands[codex]}
  fi
fi

if [[ -n $REAL_CODEX ]] && ! alias codex &>/dev/null; then
  codex() {
    ALL_PROXY=socks5h://127.0.0.1:1086 $REAL_CODEX "$@"
  }
fi

# -----------------------------------------------------------------------------
# claude
if can-exec claude && [[ "${NO_PROXY_CLAUDE:-0}" != '1' ]]; then
  if [[ -z $REAL_CLAUDE ]]; then
    export REAL_CLAUDE=${commands[claude]}
  fi
fi

if [[ -n $REAL_CLAUDE ]] && ! alias claude &>/dev/null; then
  claude() {
    ALL_PROXY=socks5h://127.0.0.1:1086 $REAL_CLAUDE "$@"
  }
fi

# -----------------------------------------------------------------------------
# cursor-agent
if can-exec cursor-agent && [[ "${NO_PROXY_CURSOR:-0}" != '1' ]] && [[ "${NO_PROXY_CURSOR_AGENT:-0}" != '1' ]]; then
  if [[ -z $REAL_CURSOR_AGENT ]]; then
    export REAL_CURSOR_AGENT=${commands[cursor-agent]}
  fi
fi

if [[ -n $REAL_CURSOR_AGENT ]] && ! alias cursor-agent &>/dev/null; then
  cursor-agent() {
    ALL_PROXY=socks5h://127.0.0.1:1086 $REAL_CURSOR_AGENT "$@"
  }
fi

if [[ -n $REAL_CURSOR_AGENT ]] && ! alias agent &>/dev/null; then
  agent() {
    ALL_PROXY=socks5h://127.0.0.1:1086 $REAL_CURSOR_AGENT "$@"
  }
fi

# -----------------------------------------------------------------------------
# go
export GOTESTSUM_FORMAT=testname

# -----------------------------------------------------------------------------
# python
if can-exec python3 && ! can-exec python; then
  python() {
    python3 "$@"
  }
fi

alias pip='python -m pip'
alias pip2='python2 -m pip'
alias pip3='python3 -m pip'

if can-exec pyenv; then
  lazyload pyenv -- 'eval "$(pyenv init -)"'
fi

alias p='python3'
alias p2='python2'
alias pp='python3 -m ptpython || ptpython'
alias pp-install='pip3 install ptpython --break-system-packages'
alias jn='jupyter notebook'

# -----------------------------------------------------------------------------
# docker
export DOCKER_BUILDKIT=1

if (( IS_MACOS )) && can-exec limactl; then
  export DOCKER_HOST="$(limactl list docker-rootful --format 'unix://{{.Dir}}/sock/docker.sock')"
fi

alias d='docker'
alias dc='docker-compose'

# -----------------------------------------------------------------------------
# k8s
alias k='kubectl'

# -----------------------------------------------------------------------------
# swagger
alias open-swagger='open-swagger-ui --open'

# -----------------------------------------------------------------------------
# utils
random-string() {
  local arg=$1
  openssl rand -hex "$((arg / 2))"
}

alias timestamp='date +%s'

is-ip-in-net() {
  python3 -c 'import sys; from ipaddress import ip_address, ip_network; print(ip_address(sys.argv[1]) in ip_network(sys.argv[2]))' "$1" "$2"
}

decode-json-data() {
  python3 -c 'import sys,json; sys.stdout.buffer.write(json.load(sys.stdin)["data"].encode("latin1"))'
}

# -----------------------------------------------------------------------------
# encode / decode
encode-url() {
  python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1]))' "$1"
}

decode-url() {
  python3 -c 'import sys, urllib.parse; print(urllib.parse.unquote_plus(sys.argv[1]))' "$1"
}

encode-html() {
  python3 -c 'import sys, html; print(html.escape(sys.argv[1]))' "$1"
}

decode-html() {
  python3 -c 'import sys, html; print(html.unescape(sys.argv[1]))' "$1"
}

encode-base64() {
  python3 -c 'import sys, base64; sys.stdout.buffer.write(base64.b64encode(sys.argv[1].encode()))' "$1"
}

decode-base64() {
  python3 -c 'import sys, base64; sys.stdout.buffer.write(base64.b64decode(sys.argv[1]))' "$1"
}

# -----------------------------------------------------------------------------
# flags
decode-flags-bin() {
  python3 -c 'import sys; print([f"(1 << {i})" for i, v in enumerate(bin(int(sys.argv[1]))[2:][::-1]) if v == "1"])' "$1"
}

decode-flags-hex() {
  python3 -c 'import sys; print([hex(1 << i) for i, v in enumerate(bin(int(sys.argv[1]))[2:][::-1]) if v == "1"])' "$1"
}

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
