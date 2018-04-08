set nocompatible

let mapleader = ","


" plugins
call plug#begin('~/.vim/bundle')

" " generic
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'

" " editing
Plug 'vim-scripts/AutoComplPop'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'Raimondi/delimitMate'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-sleuth'
Plug 'editorconfig/editorconfig-vim'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'pbrisbin/vim-mkdir'

" " navigation
Plug 'tpope/vim-unimpaired'
Plug 'scrooloose/nerdtree'
Plug 'ap/vim-buftabline'

" " appearance
Plug 'morhetz/gruvbox'
Plug 'luochen1990/rainbow'
Plug 'mhinz/vim-signify'
Plug 'ekalinin/Dockerfile.vim'
Plug 'vim-scripts/nginx.vim'


call plug#end()


" plugin settings
" " maxbrunsfeld/vim-yankstack
let g:yankstack_map_keys = 0
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" " scrooloose/nerdtree
map <leader>f :NERDTreeToggle<CR>

" " luochen1990/rainbow
let g:rainbow_active = 1

" " terryma/vim-multiple-cursors
let g:multi_cursor_use_default_mapping = 0
noremap <c-g> <nop>
noremap <c-u> <nop>
noremap <c-k> <nop>
let g:multi_cursor_next_key='<C-g>'
let g:multi_cursor_prev_key='<C-u>'
let g:multi_cursor_skip_key='<C-k>'
let g:multi_cursor_quit_key='<Esc>'


" vim mappings
map 0 ^
nnoremap j gj
nnoremap k gk
noremap <F1> <ESC>

nnoremap - :noh<cr>

nnoremap _ :bp<CR>
nnoremap + :bn<CR>
nnoremap <leader>q :bp<cr>:bd #<cr>
cmap bq bd

nnoremap <c-s> :wa<cr>
inoremap <c-s> <c-o>:wa<cr>
vnoremap <c-s> <esc>:wa<cr>gv
cmap w!! w !sudo tee % >/dev/null

nnoremap [op :set clipboard=unnamed<CR>
nnoremap ]op :set clipboard=<CR>
nnoremap cop :set <C-R>=&clipboard == 'unnamed' ? 'clipboard=' : 'clipboard=unnamed'<CR><CR>


" colors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

let g:gruvbox_contrast_dark='hard'

syntax enable
set background=dark
colorscheme gruvbox


" vim settings
" " editor appearance
set number
set cul
set showmatch
set scrolloff=5
set sidescrolloff=5

set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab

set list
set listchars=tab:»\ ,trail:·,nbsp:·,precedes:<,extends:>

set mat=2

set shortmess+=aIT
if has("patch-7.4.314")
  set shortmess+=c
endif
set title
set confirm
set more
set ruler
set showmode
set showcmd

set foldenable
set foldmethod=syntax
set foldlevelstart=99

set nowrap
set linebreak
if exists('+breakindent')
  set breakindent
endif
set showbreak=+++\ 

" " gvim
set guioptions=gi

" " navigation
set incsearch
set hlsearch
set ignorecase
set smartcase

set magic

set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*~,*.pyc,.git/*,*.meta,.sync/*

set nostartofline

" " editing
set autoindent
set copyindent
set smartindent
set smarttab

set nrformats-=octal

set viewoptions=folds,cursor,unix,slash

set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set completeopt=longest,menuone,preview
set splitright
set splitbelow

set modeline
set modelines=5

set undofile
set autoread
set autowriteall

set nospell

" " encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp1251,latin1
set fileformats=unix,dos,mac

" " russian support
set keymap=russian-jcukenwin
set spelllang=ru_yo,en_us
set iskeyword=@,48-57,_,192-255
set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>
set iminsert=0
set imsearch=0

" " other
set backupdir=~/.vim/backup
set directory=~/.vim/tmp
set undodir=~/.vim/undo
set viewdir=~/.vim/view
if &shell =~# 'fish$'
  set shell=/bin/bash
endif

set mouse=a
set hidden
set lazyredraw
set noerrorbells
set novisualbell
set history=700
set ttyfast
set timeout
set timeoutlen=1000
set ttimeout
set ttimeoutlen=10
