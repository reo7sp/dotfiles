let g:loaded_netrwPlugin = 1
let g:loaded_netrw = 1
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0

let mapleader = " "
let maplocalleader = " "
nnoremap <space> <nop>


" =============================================================================
" plugins
if has('nvim')
  lua vim.loader.enable()
  call plug#begin('~/.vim/nbundle')
else
  call plug#begin('~/.vim/bundle')
endif

" -----------------------------------------------------------------------------
" generic
if ! has('nvim')
  Plug 'tpope/vim-sensible'
  Plug 'Shougo/vimproc.vim', {'do': 'make'}
endif
if has('nvim')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'kevinhwang91/promise-async'
  Plug 'kkharji/sqlite.lua'
  Plug 'MunifTanjim/nui.nvim'
  Plug 'ray-x/guihua.lua'
endif
Plug 'tpope/vim-repeat'

" -----------------------------------------------------------------------------
" editor
if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'RubixDev/mason-update-all'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'rafamadriz/friendly-snippets'
  Plug 'milanglacier/minuet-ai.nvim'
  Plug 'xzbdmw/colorful-menu.nvim'
  Plug 'saghen/blink.cmp', {'tag': 'v1.*'}
else
  Plug 'vim-scripts/AutoComplPop'
endif
if has('nvim')
  Plug 'windwp/nvim-autopairs'
else
  Plug 'Raimondi/delimitMate'
end
Plug 'alvan/vim-closetag', {'for': ['html', 'htm', 'xml', 'js', 'jsx', 'ts', 'tsx']}
Plug 'haya14busa/vim-asterisk'
Plug 'wellle/targets.vim'
if has('nvim')
  Plug 'monaqa/dial.nvim'
endif
if ! has('nvim')
  Plug 'ConradIrwin/vim-bracketed-paste'
endif
Plug 'romainl/vim-cool'
if has('nvim')
  Plug 'nmac427/guess-indent.nvim'
else
  Plug 'tpope/vim-sleuth'
endif
if has('nvim')
  Plug 'lewis6991/spaceless.nvim'
else
  Plug 'thirtythreeforty/lessspace.vim'
endif
Plug 'ntpeters/vim-better-whitespace'
Plug 'justinmk/vim-sneak'
if has('nvim')
  Plug 'ysmb-wtsg/in-and-out.nvim'
endif
if has('nvim')
  Plug 'keaising/im-select.nvim'
endif
if has('nvim')
  Plug 'kylechui/nvim-surround'
else
  Plug 'tpope/vim-surround'
endif
if has('nvim')
  Plug 'gbprod/substitute.nvim'
else
  Plug 'svermeulen/vim-subversive'
endif
if has('nvim')
  Plug 'gbprod/yanky.nvim'
else
  Plug 'maxbrunsfeld/vim-yankstack'
endif
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
if has('nvim')
  Plug 'kevinhwang91/nvim-ufo'
endif
if has('nvim')
  Plug 'numToStr/Comment.nvim'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
else
  Plug 'tpope/vim-commentary'
endif
if has('nvim')
  Plug 'Wansmer/treesj'
else
  Plug 'AndrewRadev/splitjoin.vim'
endif
if has('nvim')
  Plug 'johmsalas/text-case.nvim'
endif
if has('nvim')
  Plug 'echasnovski/mini.align'
endif
if has('nvim')
  Plug 'ThePrimeagen/refactoring.nvim'
endif
if has('nvim')
  Plug 'danymat/neogen'
endif
if has('nvim')
  Plug 'stevearc/conform.nvim'
endif
Plug 'chrisbra/NrrwRgn'
if has('nvim')
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'akinsho/git-conflict.nvim', {'tag': '*'}
else
  Plug 'airblade/vim-gitgutter'
endif

" -----------------------------------------------------------------------------
" appearance
if has('nvim')
  Plug 'catppuccin/nvim', {'as': 'catppuccin'}
else
  Plug 'rakr/vim-one'
end
if has('nvim')
  Plug 'nvim-lualine/lualine.nvim'
else
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
endif
if has('nvim')
  Plug 'romgrk/barbar.nvim'
else
  Plug 'ap/vim-buftabline'
endif
if has('nvim')
  Plug 's1n7ax/nvim-window-picker'
  Plug 'sindrets/winshift.nvim'
endif
if has('nvim')
  Plug 'kevinhwang91/nvim-bqf'
  Plug 'stevearc/quicker.nvim'
endif
if has('nvim')
  Plug 'folke/trouble.nvim'
endif
if has('nvim')
  Plug 'chentoast/marks.nvim'
  Plug 'lewis6991/satellite.nvim'
endif
if has('nvim')
  Plug 'RRethy/vim-illuminate'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'lukas-reineke/virt-column.nvim'
  Plug 'sitiom/nvim-numbertoggle'
endif
if has('nvim')
  Plug 'rachartier/tiny-inline-diagnostic.nvim'
endif
if has('nvim')
  Plug 'j-hui/fidget.nvim'
endif
if has('nvim')
  Plug 'folke/which-key.nvim'
else
  Plug 'liuchengxu/vim-which-key'
  Plug 'junegunn/vim-peekaboo'
endif

" -----------------------------------------------------------------------------
" file management
Plug 'bogado/file-line'
Plug 'pbrisbin/vim-mkdir'
if has('nvim')
  Plug 'okuuva/auto-save.nvim'
else
  Plug '907th/vim-auto-save'
endif
Plug 'farmergreg/vim-lastplace'
if has('nvim')
  Plug 'ahmedkhalf/project.nvim'
endif
if ! has('nvim')
  Plug 'moll/vim-bbye'
  Plug 'vim-scripts/BufOnly.vim'
endif
if has('nvim')
  Plug 'Shatur/neovim-session-manager'
endif

" -----------------------------------------------------------------------------
" navigation
Plug 'reo7sp/vim-unimpaired'
if has('nvim')
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}
  Plug 'nvim-telescope/telescope-ui-select.nvim'
  Plug 'smartpde/telescope-recent-files'
  Plug 'nvim-telescope/telescope-live-grep-args.nvim'
  Plug 'princejoogie/dir-telescope.nvim'
  Plug 'LukasPietzschmann/telescope-tabs'
  Plug 'jmacadie/telescope-hierarchy.nvim'
  Plug 'piersolenski/import.nvim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
endif
if has('nvim')
  Plug 'stevearc/oil.nvim'
endif
if has('nvim')
  Plug 'nvim-tree/nvim-tree.lua'
endif
if has('nvim')
  Plug 'rgroli/other.nvim'
endif
if has('nvim')
  Plug 'stevearc/aerial.nvim'
endif
if has('nvim')
  Plug 'MagicDuck/grug-far.nvim'
endif

" -----------------------------------------------------------------------------
" language specific
let g:polyglot_disabled = ['sensible', 'autoindent']
Plug 'sheerun/vim-polyglot'
if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
endif
if has('nvim')
  Plug 'RRethy/vim-hexokinase', {'do': 'make hexokinase'}
endif
if has('nvim')
  Plug 'reo7sp/go.nvim'
else
  Plug 'johejo/gomod.vim'
endif
Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'}
Plug 'HiPhish/jinja.vim'
if has('nvim')
  Plug 'MeanderingProgrammer/render-markdown.nvim'
endif
if has('nvim')
  Plug 'hat0uma/csvview.nvim', {'for': ['csv', 'tsv']}
endif
Plug 'rodjek/vim-puppet', {'for': ['pascal', 'puppet']}
Plug 'fladson/vim-kitty'

" -----------------------------------------------------------------------------
" commands
if has('nvim')
  Plug 'akinsho/toggleterm.nvim'
endif
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-dispatch'
if has('nvim')
  Plug 'stevearc/overseer.nvim'
endif
Plug 'tpope/vim-fugitive'
let g:DiffCharDoMapping = 0
Plug 'rickhowe/diffchar.vim'
let g:VDiffDoMapping = 0
Plug 'rickhowe/spotdiff.vim'
if has('nvim')
  Plug 'sindrets/diffview.nvim'
  Plug 'kdheepak/lazygit.nvim'
endif
function! BuildGitlabNvim(_) abort
  lua require('gitlab.server').build(true)
endfunction
if has('nvim')
  Plug 'harrisoncramer/gitlab.nvim', {'do': function('BuildGitlabNvim')}
endif

call plug#end()


" =============================================================================
" colors
if has('termguicolors')
  set termguicolors
endif

if ! has('nvim')
  " https://github.com/kovidgoyal/kitty/issues/108#issuecomment-320492663
  let &t_ut=''
endif

if has('nvim')
  lua << EOF
  require('catppuccin').setup({
    integrations = {
      aerial = true,
      barbar = true,
      blink_cmp = true,
      diffview = true,
      fidget = true,
      gitsigns = true,
      grug_far = true,
      mason = true,
      nvim_surround = true,
      ufo = true,
      window_picker = true,
      overseer = true,
      render_markdown = true,
      telescope = {
        enabled = true,
      },
      lsp_trouble = true,
      illuminate = {
        enabled = true,
        lsp = false
      },
      vim_sneak = true,
      which_key = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { 'undercurl' },
          hints = { 'undercurl' },
          warnings = { 'undercurl' },
          information = { 'undercurl' },
        },
      },
    }
  })

  if os.getenv('VIM_COLORS_DARK') == '1' then
    vim.cmd([[colorscheme catppuccin-mocha]])
  else
    vim.cmd([[colorscheme catppuccin-latte]])
    vim.cmd([[highlight CursorLine guibg=#e4e4e4]])
  end
EOF
else
  set background=light
  let g:airline_theme='sol'
  colorscheme one
endif


" =============================================================================
" plugin settings

" -----------------------------------------------------------------------------
" ray-x/guihua.lua
function! InitGuihua() abort
  lua << EOF
  require('guihua').setup({
    maps = {
      split = '<C-x>',
    },
    icons = {
      syntax = {
        var = '',
        method = '',
        ['function'] = '',
        ['arrow_function'] = '',
        parameter = '',
        associated = '',
        namespace = '',
        type = '',
        field = '',
        interface = '',
        module = '',
        flag = '',
      },
    },
  })
EOF
endfunction

if has('nvim')
  call InitGuihua()
endif

" -----------------------------------------------------------------------------
" williamboman/mason.nvim
function! InitLSP() abort
  lua << EOF
  local lspconfig_defaults = require('lspconfig').util.default_config
  lspconfig_defaults.capabilities = vim.tbl_deep_extend('force', lspconfig_defaults.capabilities,
    require('blink.cmp').get_lsp_capabilities({}, false))

  require('mason').setup({})

  local lsp_custom = {
    clangd = {
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--completion-style=detailed',
      },
    },
    gopls = {
      settings = {
        gopls = {
          analyses = {
            useany = false,
          },
        },
      },
    },
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              'vim',
              'box',
            },
          },
        },
      },
    },
  }
  require('mason-lspconfig').setup({
    ensure_installed = {
      'clangd',
      'cmake',
      'gopls',
      'pyright',
      'perlnavigator',
      'lua_ls',
      'rust_analyzer',
      'bashls',
      'html',
      'cssls',
      'ts_ls',
      'jinja_lsp',
      'sqlls',
      'jsonls',
      'yamlls',
      'lemminx',
      'dockerls',
      'docker_compose_language_service',
      'ansiblels',
      'puppet',
      'gh_actions_ls',
      'gitlab_ci_ls',
    },
    handlers = {
      function(server_name)
        require('lspconfig')[server_name].setup(lsp_custom[server_name] or {})
      end,
    },
  })

  require('mason-update-all').setup({})
EOF

  nnoremap K <cmd>lua vim.lsp.buf.hover()<cr>
  inoremap <C-S> <cmd>lua vim.lsp.buf.signature_help()<cr>
  nnoremap <nowait> gr <cmd>lua vim.lsp.buf.rename()<cr>
  nnoremap g: <cmd>lua vim.lsp.buf.code_action()<cr>
  vnoremap g: <cmd>lua vim.lsp.buf.code_action()<cr>
  nnoremap gO <nop>
endfunction

if has('nvim')
  call InitLSP()
endif

" -----------------------------------------------------------------------------
" L3MON4D3/LuaSnip
function! InitSnip() abort
  lua << EOF
  require('luasnip.loaders.from_vscode').lazy_load()
EOF
endfunction

if has('nvim')
  call InitSnip()
endif

" -----------------------------------------------------------------------------
" milanglacier/minuet-ai.nvim
function! InitLLM() abort
  lua << EOF
  local preset_configs = {
    ['local'] = {
      provider = 'openai_fim_compatible',
      provider_options = {
        openai_fim_compatible = {
          name = 'local',
          end_point = 'http://localhost:11434/v1/completions',
          api_key = 'TERM',
          stream = true,
          model = 'qwen2.5-coder:3b',
          optional = {
            max_tokens = 64,
            top_p = 0.9,
          },
        },
      },
    },
    remote = {
      provider = 'openai_compatible',
      provider_options = {
        openai_compatible = vim.tbl_extend('force', {
          name = 'remote',
        }, require('minuet_llm_remote_config')),
      },
    },
  }
  require('minuet').setup({
    presets = preset_configs,
    blink = {
      enable_auto_complete = false,
    },
    n_completions = 1,
    context_window = 1024,
    request_timeout = 3,
  })

  local default_preset = 'local'
  if preset_configs['remote']
      and preset_configs['remote']['provider_options']
      and preset_configs['remote']['provider_options']['openai_compatible']
      and preset_configs['remote']['provider_options']['openai_compatible']['end_point'] then
    default_preset = 'remote'
  end
  require('minuet').config = vim.tbl_deep_extend('force', require('minuet').config, preset_configs[default_preset])
EOF

  nnoremap <leader>= <cmd>lua if require('minuet').config['blink'].enable_auto_complete then vim.cmd([[Minuet blink disable]]) else vim.cmd([[Minuet blink enable]]) end<cr>
endfunction

if has('nvim')
  call InitLLM()
endif

" -----------------------------------------------------------------------------
" saghen/blink.cmp
function! InitBlink() abort
  lua << EOF
  require('colorful-menu').setup({})

  require('blink.cmp').setup({
    keymap = {
      preset = 'super-tab',
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-S-space>'] = require('minuet').make_blink_map(),
    },
    sources = {
      default = { 'lsp', 'path', 'buffer', 'snippets', 'minuet' },
      providers = {
        minuet = {
          name = 'minuet',
          module = 'minuet.blink',
          async = true,
          timeout_ms = 3000,
          score_offset = 50,
        },
      },
    },
    snippets = {
      preset = 'luasnip',
    },
    completion = {
      trigger = {
        prefetch_on_insert = false,
      },
      list = {
        max_items = 25,
      },
      menu = {
        draw = {
          columns = { { 'label', gap = 1 }, { 'kind' } },
          components = {
            label = {
              text = function(ctx)
                return require('colorful-menu').blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require('colorful-menu').blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
    },
    signature = {
      enabled = true,
    },
    cmdline = {
      completion = {
        list = {
          selection = {
            preselect = false,
          },
        },
        menu = {
          auto_show = true,
        },
      },
    },
  })

EOF
endfunction

if has('nvim')
  call InitBlink()
endif

" -----------------------------------------------------------------------------
" windwp/nvim-autopairs
function! InitAutopairs() abort
  lua require('nvim-autopairs').setup({})
endfunction

if has('nvim')
  call InitAutopairs()
endif

" -----------------------------------------------------------------------------
" haya14busa/vim-asterisk
function! InitAsterisk() abort
  let g:asterisk#keeppos = 1

  map *   <Plug>(asterisk-*)
  map #   <Plug>(asterisk-#)
  map g*  <Plug>(asterisk-g*)
  map g#  <Plug>(asterisk-g#)
  map z*  <Plug>(asterisk-z*)
  map gz* <Plug>(asterisk-gz*)
  map z#  <Plug>(asterisk-z#)
  map gz# <Plug>(asterisk-gz#)
endfunction

call InitAsterisk()

" -----------------------------------------------------------------------------
" monaqa/dial.nvim
function! InitDial() abort
  lua << EOF
  local augend = require('dial.augend')
  require('dial.config').augends:register_group({
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias['%Y-%m-%d'],
      augend.constant.alias.bool,
      augend.constant.new({
        elements = { 'and', 'or' },
        word = true,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { '&&', '||' },
        word = false,
        cyclic = true,
      }),
    },
  })
EOF

  nmap  <C-a>  <Plug>(dial-increment)
  nmap  <C-x>  <Plug>(dial-decrement)
  nmap g<C-a> g<Plug>(dial-increment)
  nmap g<C-x> g<Plug>(dial-decrement)
  vmap  <C-a>  <Plug>(dial-increment)
  vmap  <C-x>  <Plug>(dial-decrement)
  vmap g<C-a> g<Plug>(dial-increment)
  vmap g<C-x> g<Plug>(dial-decrement)
endfunction

if has('nvim')
  call InitDial()
endif

" -----------------------------------------------------------------------------
" nmac427/guess-indent.nvim
function! InitGuessIndent() abort
  lua require('guess-indent').setup({})
endfunction

if has('nvim')
  call InitGuessIndent()
endif

" -----------------------------------------------------------------------------
" ntpeters/vim-better-whitespace
function! InitBetterWhitespace() abort
  let g:better_whitespace_enabled = 0
  let g:better_whitespace_operator = ''
  let g:strip_max_file_size = 99999
  let g:strip_whitespace_confirm = 0

  nnoremap ]w <cmd>NextTrailingWhitespace<CR>
  nnoremap [w <cmd>PrevTrailingWhitespace<CR>
endfunction

call InitBetterWhitespace()

" -----------------------------------------------------------------------------
" justinmk/vim-sneak
function! InitSneak() abort
  let g:sneak#use_ic_scs = 1

  map f <Plug>Sneak_f
  map F <Plug>Sneak_F
  map t <Plug>Sneak_t
  map T <Plug>Sneak_T
endfunction

call InitSneak()

" -----------------------------------------------------------------------------
" ysmb-wtsg/in-and-out.nvim
function! InitInOut() abort
  inoremap <C-CR> <cmd>lua require('in-and-out').in_and_out()<cr>
endfunction

if has('nvim')
  call InitInOut()
endif

" -----------------------------------------------------------------------------
" keaising/im-select.nvim
function! InitImSelect() abort
  lua << EOF
  require('im_select').setup({})
EOF
endfunction

if has('nvim')
  call InitImSelect()
endif

" -----------------------------------------------------------------------------
" kylechui/nvim-surround
function! InitNvimSurround() abort
  lua << EOF
  require('nvim-surround').setup({
    move_cursor = false,
  })
EOF
endfunction

if has('nvim')
  call InitNvimSurround()
endif

" -----------------------------------------------------------------------------
" gbprod/substitute.nvim or svermeulen/vim-subversive
function! InitSubstitute() abort
  lua << EOF
  require('substitute').setup({
    range = {
      prefix = 'x',
    },
  })

  vim.keymap.set('n', 'x', require('substitute').operator)
  vim.keymap.set('n', 'xx', require('substitute').line)
  vim.keymap.set('n', 'X', require('substitute').eol)
  vim.keymap.set('x', 'x', require('substitute').visual)
EOF
endfunction

function! InitSubversive() abort
  nmap x <plug>(SubversiveSubstitute)
  nmap xx <plug>(SubversiveSubstituteLine)
  nmap X <plug>(SubversiveSubstituteToEndOfLine)
endfunction

if has('nvim')
  call InitSubstitute()
else
  autocmd BufEnter * call InitSubversive()
endif

" -----------------------------------------------------------------------------
" gbprod/yanky.nvim or maxbrunsfeld/vim-yankstack
function! InitYanky() abort
  lua << EOF
  require('yanky').setup({
    ring = {
      storage = 'sqlite',
    },
    system_clipboard = {
      sync_with_ring = false,
    },
    preserve_cursor_position = {
      enabled = true,
    },
    textobj = {
      enabled = true,
    },
  })

  vim.keymap.set({ 'n', 'x' }, 'y', '<Plug>(YankyYank)')
  vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
  vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
  vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
  vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')
  vim.keymap.set('n', ']p', '<Plug>(YankyPutIndentAfterLinewise)')
  vim.keymap.set('n', '[p', '<Plug>(YankyPutIndentBeforeLinewise)')
  vim.keymap.set('n', ']P', '<Plug>(YankyPutIndentAfterLinewise)')
  vim.keymap.set('n', '[P', '<Plug>(YankyPutIndentBeforeLinewise)')
  vim.keymap.set('n', '>p', '<Plug>(YankyPutIndentAfterShiftRight)')
  vim.keymap.set('n', '<p', '<Plug>(YankyPutIndentAfterShiftLeft)')
  vim.keymap.set('n', '>P', '<Plug>(YankyPutIndentBeforeShiftRight)')
  vim.keymap.set('n', '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)')
  vim.keymap.set('n', '=p', '<Plug>(YankyPutAfterFilter)')
  vim.keymap.set('n', '=P', '<Plug>(YankyPutBeforeFilter)')
  vim.keymap.set({ 'o', 'x' }, 'iy', function() require('yanky.textobj').last_put() end, {})
  vim.keymap.set('n', '[y', '<Plug>(YankyPreviousEntry)')
  vim.keymap.set('n', ']y', '<Plug>(YankyNextEntry)')
EOF
endfunction

function! InitYankStack() abort
  let g:yankstack_map_keys = 0

  nnoremap ]y <Plug>yankstack_substitute_older_paste
  nnoremap [y <Plug>yankstack_substitute_newer_paste
endfunction

if has('nvim')
  call InitYanky()
else
  call InitYankStack()
endif

" -----------------------------------------------------------------------------
" mbbill/undotree
function! InitUndotree() abort
  let g:undotree_WindowLayout = 3
  let g:undotree_SetFocusWhenToggle = 1
  let g:undotree_SplitWidth = 80

  nnoremap <leader>u <cmd>UndotreeToggle<cr>
endfunction

call InitUndotree()

" -----------------------------------------------------------------------------
" kevinhwang91/nvim-ufo
function! InitUfo() abort
  lua << EOF
  vim.o.foldlevel = 999
  vim.o.foldlevelstart = 999
  vim.o.foldenable = true

  require('ufo').setup({
    open_fold_hl_timeout = 0,
    provider_selector = function(bufnr, filetype, buftype)
      return { 'indent' }
    end
  })

  vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
  vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
  vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
  vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
EOF
endfunction

if has('nvim')
  call InitUfo()
end

" -----------------------------------------------------------------------------
" numToStr/Comment.nvim or tpope/vim-commentary
function! InitComment() abort
  lua << EOF
  require('ts_context_commentstring').setup({
    enable_autocmd = false,
  })
  require('Comment').setup({
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  })
EOF
endfunction

if has('nvim')
  call InitComment()
end

" -----------------------------------------------------------------------------
" Wansmer/treesj or AndrewRadev/splitjoin.vim
function! InitTreeSJ() abort
  lua << EOF
  require('treesj').setup({
    use_default_keymaps = false,
    max_join_length = 9999,
  })
EOF

  nnoremap gm <cmd>lua require('treesj').toggle()<cr>
  nnoremap gM <nop>
endfunction

function! LazyInitTreeSJ() abort
  lua vim.keymap.set('n', 'gm', function() vim.call('InitTreeSJ') vim.api.nvim_input('gm') end, { desc = 'Merge statements' })
endfunction

function! InitSplitJoin() abort
  let g:splitjoin_split_mapping = ''
  let g:splitjoin_join_mapping = ''

  nnoremap gm <cmd>SplitjoinSplit<cr>
endfunction

if has('nvim')
  call LazyInitTreeSJ()
else
  call InitSplitJoin()
endif

" -----------------------------------------------------------------------------
" johmsalas/text-case.nvim
function! InitTextCase() abort
  lua << EOF
  require('textcase').setup({
    prefix = 'gt',
  })
EOF

  nnoremap gT <Nop>
endfunction

if has('nvim')
  call InitTextCase()
endif

" -----------------------------------------------------------------------------
" echasnovski/mini.align
function! InitMiniAlign() abort
  lua << EOF
  require('mini.align').setup({
    mappings = {
      start = '',
      start_with_preview = 'ga',
    },
  })
EOF
endfunction

if has('nvim')
  call InitMiniAlign()
endif

" -----------------------------------------------------------------------------
" ThePrimeagen/refactoring.nvim
function! InitRefactoring() abort
  lua << EOF
  require('refactoring').setup({})
  require('telescope').load_extension('refactoring')

  vim.keymap.set({ 'n', 'x' }, 'gR', function()
    require('telescope').extensions.refactoring.refactors(
      vim.tbl_extend('force', require('telescope.themes').get_cursor({
        layout_config = {
          height = 15+4,
        },
      }), {
      })
    )
  end, { desc = 'Refactor' })
EOF
endfunction

function! LazyInitRefactoring() abort
  lua vim.keymap.set({ 'n', 'x' }, 'gR', function() vim.call('InitRefactoring') vim.api.nvim_input('gR') end, { desc = 'Refactor' })
endfunction

if has('nvim')
  call LazyInitRefactoring()
endif

" -----------------------------------------------------------------------------
" danymat/neogen
function! InitNeogen() abort
  lua << EOF
  require('neogen').setup({})
EOF
endfunction

if has('nvim')
  call InitNeogen()
endif

" -----------------------------------------------------------------------------
" stevearc/conform.nvim
function! InitConform() abort
  lua << EOF
  require('conform').setup({
    formatters_by_ft = {
      c = {
        'clang_format',
      },
      cpp = {
        'clang_format',
      },
      go = {
        'goimports',
        'gofmt',
      },
      python = {
        'isort',
        'black',
      },
      lua = {
        'stylua',
      },
      html = {
        'prettier',
      },
      css = {
        'prettier',
      },
      javascript = {
        'prettier',
      },
      typescript = {
        'prettier',
      },
      tsx = {
        'prettier',
      },
      jsx = {
        'prettier',
      },
      sh = {
        'shfmt',
      },
      json = {
        'jq',
      },
      yaml = {
        'yamlfmt',
      },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
  })

  vim.api.nvim_create_user_command('Format', function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ['end'] = { args.line2, end_line:len() },
      }
    end
    require('conform').format({ async = true, lsp_format = 'fallback', range = range })
  end, { range = true })

  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      vim.api.nvim_buf_set_option(args.buf, 'formatexpr', 'v:lua.require("conform").formatexpr()')
    end,
  })
EOF

  nnoremap gQ <cmd>lua require('conform').format({})<cr>
endfunction

if has('nvim')
  call InitConform()
endif

" -----------------------------------------------------------------------------
" lewis6991/gitsigns.nvim
function! InitGitSigns() abort
  lua << EOF
  require('gitsigns').setup({
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      map('n', ']h', function()
        if vim.wo.diff then
          vim.cmd.normal({']h', bang = true})
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = 'Next git hunk' })
      map('n', '[h', function()
        if vim.wo.diff then
          vim.cmd.normal({'[h', bang = true})
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = 'Prev git hunk' })

      vim.keymap.set({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<CR>')
    end
  })
EOF

  nnoremap <c-w>g <cmd>Gitsigns blame_line<CR>
  nnoremap <silent> <leader>gh :Gitsigns blame<CR>:lua vim.defer_fn(function () vim.cmd([[wincmd w]]) end, 200)<CR>
endfunction

if has('nvim')
  call InitGitSigns()
endif

" -----------------------------------------------------------------------------
" akinsho/git-conflict.nvim
function! InitGitConflict() abort
  lua << EOF
  require('git-conflict').setup({
    disable_diagnostics = true,
  })
EOF
endfunction

if has('nvim')
  call InitGitConflict()
endif

" -----------------------------------------------------------------------------
" nvim-lualine/lualine.nvim or vim-airline/vim-airline
function! InitLualine() abort
  lua << EOF
  -- git integration
  local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed,
      }
    end
  end

  -- dynamic width
  local conditions = {
    hide_in_width_first = function()
      return vim.fn.winwidth(0) > 140
    end,
    hide_in_width_middle = function()
      return vim.fn.winwidth(0) > 120
    end,
    hide_in_width_last = function()
      return vim.fn.winwidth(0) > 80
    end,
  }

  local lualine = require('lualine')
  lualine.setup({
    options = {
      theme = 'tomorrow',
      icons_enabled = false,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    extensions = {
      'nvim-tree',
      'oil',
      'aerial',
      'quickfix',
      'trouble',
      'fugitive',
    },
    sections = {
      lualine_a = {
        {
          'mode',
          fmt = function(str) return str:sub(1, 1) end,
        },
      },
      lualine_b = {
      },
      lualine_c = {
        {
          'filename',
          path = 1,
          file_status = false,
        },
        {
          'aerial',
          depth = 3,
          sep = ' > ',
          padding = { left = 0, right = 1 },
          cond = conditions.hide_in_width_last,
        },
      },
      lualine_x = {
        {
          'b:gitsigns_head',
          cond = conditions.hide_in_width_first,
        },
        {
          'diff',
          source = diff_source,
          padding = { left = 0, right = 1 },
          cond = conditions.hide_in_width_middle,
        },
        {
          'filetype',
          cond = conditions.hide_in_width_middle,
        },
        {
          'lsp_status',
          symbols = { done = '' },
          padding = { left = 0, right = 1 },
          cond = conditions.hide_in_width_middle,
        },
        {
          'diagnostics',
          padding = { left = 0, right = 1 },
          cond = conditions.hide_in_width_last,
        },
        {
          function()
            local shiftwidth = vim.api.nvim_buf_get_option(0, 'shiftwidth')
            if vim.api.nvim_buf_get_option(0, 'expandtab') then
              return 'S:sw=' .. shiftwidth
            else
              return 'T:ts=' .. vim.api.nvim_buf_get_option(0, 'tabstop')
            end
          end,
          cond = conditions.hide_in_width_last
        },
        {
          require('minuet.lualine'),
        },
      },
      lualine_y = {
      },
      lualine_z = {
        'location',
        'searchcount',
        'selectioncount',
      },
    },
    inactive_sections = {
      lualine_a = {
      },
      lualine_b = {
      },
      lualine_c = {
        {
          'filename',
          path = 1,
          file_status = false,
        },
      },
      lualine_x = {
        'location',
      },
      lualine_y = {
      },
      lualine_z = {
      },
    },
  })

  local bg = '#C8C8C8'
  local fg = '#666666'
  for _, grp in ipairs({
    'lualine_a_inactive','lualine_b_inactive','lualine_c_inactive',
    'lualine_x_inactive','lualine_y_inactive','lualine_z_inactive',
  }) do
    vim.api.nvim_set_hl(0, grp, { bg = bg, fg = fg })
  end

  vim.o.fillchars = "vert:┃"
  vim.api.nvim_set_hl(0, 'WinSeparator', { fg = bg, bold = true })
EOF

  set noruler
endfunction

function! InitAirline() abort
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  let g:airline_powerline_fonts = 0
  let g:airline_symbols.branch = '⎇'
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.readonly = '∥'
  let g:airline_symbols.whitespace = 'Ξ'
  let g:airline_symbols.linenr = ''
  let g:airline_symbols.maxlinenr = ''
  let g:airline_symbols.colnr = ':'

  let g:airline_skip_empty_sections = 1
  autocmd User AirlineAfterInit :let g:airline_section_y = ''
  autocmd User AirlineAfterInit :let g:airline_section_z = airline#section#create(['linenr', 'colnr'])

  let g:airline#extensions#whitespace#enabled = 0

  let g:airline_mode_map = {
    \ '__'     : '-',
    \ 'c'      : 'C',
    \ 'i'      : 'I',
    \ 'ic'     : 'I',
    \ 'ix'     : 'I',
    \ 'n'      : 'N',
    \ 'multi'  : 'M',
    \ 'ni'     : 'N',
    \ 'no'     : 'N',
    \ 'R'      : 'R',
    \ 'Rv'     : 'R',
    \ 's'      : 'S',
    \ 'S'      : 'S',
    \ '␓'      : 'S',
    \ 't'      : 'T',
    \ 'v'      : 'V',
    \ 'V'      : 'V',
    \ '␖'      : 'V',
    \ }
endfunction

if has('nvim')
  call InitLualine()
else
  call InitAirline()
endif

" -----------------------------------------------------------------------------
" romgrk/barbar.nvim or ap/vim-buftabline
function! InitBarbar() abort
  lua << EOF
  vim.g.barbar_auto_setup = false
  require('barbar').setup({
    animation = false,
    icons = {
      buffer_index = true,
      button = false,
      filetype = {
        enabled = false,
      },
      gitsigns = {
        enabled = false,
      },
      separator = {
        right = ' ',
      },
      inactive = {
        separator = {
          right = ' ',
        },
      },
      modified = {
        button = '',
      },
      pinned = {
        filename = true,
        separator = {
          right = ' ★ ',
        },
      },
      separator_at_end = false,
    },
    minimum_padding = 0,
    maximum_padding = 0,
    sidebar_filetypes = {},
    no_name_title = '[No Name]',
  })
EOF

  highlight! link BufferCurrentMod BufferCurrent
  highlight! link BufferInactiveMod BufferInactive

  nnoremap <C-Tab> <cmd>BufferNext<CR>
  nnoremap <C-S-Tab> <cmd>BufferPrevious<CR>
  nnoremap <C-[> <cmd>BufferPrevious<CR>
  nnoremap <C-]> <cmd>BufferNext<CR>
  nnoremap [b <cmd>BufferPrevious<CR>
  nnoremap ]b <cmd>BufferNext<CR>
  nnoremap <C-1> <cmd>BufferGoto 1<CR>
  nnoremap <C-2> <cmd>BufferGoto 2<CR>
  nnoremap <C-3> <cmd>BufferGoto 3<CR>
  nnoremap <C-4> <cmd>BufferGoto 4<CR>
  nnoremap <C-5> <cmd>BufferGoto 5<CR>
  nnoremap <C-6> <cmd>BufferGoto 6<CR>
  nnoremap <C-7> <cmd>BufferGoto 7<CR>
  nnoremap <C-8> <cmd>BufferGoto 8<CR>
  nnoremap <C-9> <cmd>BufferLast<CR>

  cnoreabbrev bq BufferClose
  cnoreabbrev bd BufferClose
  nnoremap <c-q> <cmd>BufferClose<cr>
  nnoremap <c-w>Q <cmd>BufferClose<cr>
  cnoreabbrev bo BufferCloseAllButCurrentOrPinned
  cnoreabbrev bon BufferCloseAllButCurrentOrPinned
  cnoreabbrev bonly BufferCloseAllButCurrentOrPinned
  nnoremap <c-w>O <cmd>BufferCloseAllButCurrentOrPinned<cr>
  cnoreabbrev bql BufferCloseBuffersLeft
  cnoreabbrev bdl BufferCloseBuffersLeft
  cnoreabbrev bqr BufferCloseBuffersRight
  cnoreabbrev bdr BufferCloseBuffersRight

  nnoremap <C-,> <cmd>BufferMovePrevious<CR>
  nnoremap <C-.> <cmd>BufferMoveNext<CR>

  cnoreabbrev bpin BufferPin
  cnoreabbrev bpi BufferPin

  cnoreabbrev bs BufferOrderByDirectory
endfunction

function! InitBuftablineVim() abort
  nnoremap <C-Tab> <cmd>bn<CR>
  nnoremap <C-S-Tab> <cmd>bp<CR>
  nnoremap <C-[> <cmd>bp<CR>
  nnoremap <C-]> <cmd>bn<CR>
  nnoremap <C-1> <Plug>BufTabLine.Go(1)
  nnoremap <C-2> <Plug>BufTabLine.Go(2)
  nnoremap <C-3> <Plug>BufTabLine.Go(3)
  nnoremap <C-4> <Plug>BufTabLine.Go(4)
  nnoremap <C-5> <Plug>BufTabLine.Go(5)
  nnoremap <C-6> <Plug>BufTabLine.Go(6)
  nnoremap <C-7> <Plug>BufTabLine.Go(7)
  nnoremap <C-8> <Plug>BufTabLine.Go(8)
  nnoremap <C-9> <Plug>BufTabLine.Go(-1)
endfunction

if has('nvim')
  call InitBarbar()
else
  call InitBuftablineVim()
endif

" -----------------------------------------------------------------------------
" s1n7ax/nvim-window-picker
function! InitWindowPicker() abort
  lua << EOF
  require('window-picker').setup({
    hint = 'floating-big-letter',
    picker_config = {
      handle_mouse_click = true,
    },
    show_prompt = false,
    filter_rules = {
      bo = {
        filetype = {},
        buftype = {},
      },
    },
  })
EOF

  nnoremap <c-w>w <cmd>lua vim.api.nvim_set_current_win(require('window-picker').pick_window() or vim.api.nvim_get_current_win())<cr>
endfunction

if has('nvim')
  call InitWindowPicker()
endif

" -----------------------------------------------------------------------------
" sindrets/winshift.nvim
function! InitWinshift() abort
  lua << EOF
  require('winshift').setup({
    window_picker = require('window-picker').pick_window,
  })
EOF

  nnoremap <C-w>x <cmd>WinShift swap<cr>
endfunction

if has('nvim')
  call InitWinshift()
endif

" -----------------------------------------------------------------------------
" kevinhwang91/nvim-bqf
function! InitBqf() abort
  lua << EOF
  require('bqf').setup({
    preview = {
      auto_preview = false,
      winblend = 0,
      should_preview_cb = function(bufnr, qwinid)
        local ret = true
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local fsize = vim.fn.getfsize(bufname)
        if fsize > 1000 * 1024 then
          ret = false
        elseif bufname:match('^fugitive://') then
          ret = false
        end
        return ret
      end,
    },
    func_map = {
      tab = '',
      tabb = '',
      tabc = '',
      prevfile = 'K',
      nextfile = 'J',
      pscrollup = '<c-u>',
      pscrolldown = '<c-d>',
      ptoggleauto = '<c-p>',
    },
  })

  vim.api.nvim_create_autocmd('BufRead', {
    callback = function(ev)
      if vim.bo[ev.buf].buftype == 'quickfix' then
        vim.schedule(function()
          vim.keymap.set('n', '<c-t>', function()
            vim.cmd([[cclose]])
            vim.cmd([[Trouble qflist open]])
          end, { buffer = ev.buf })

          vim.keymap.set('n', 'zx', function()
            require('quicker').refresh()
          end, { buffer = ev.buf })

          vim.keymap.set('n', 'q', function()
            vim.cmd('cclose')
          end, { buffer = ev.buf })
        end)
      end
    end,
  })
EOF
endfunction

if has('nvim')
  call InitBqf()
endif

" -----------------------------------------------------------------------------
" stevearc/quicker.nvim
function! InitQuicker() abort
  lua << EOF
  require('quicker').setup({
    edit = {
      enabled = true,
      autosave = true,
    },
    highlight = {
      treesitter = true,
      lsp = false,
    },
    type_icons = {
      E = 'E',
      W = 'W',
      I = 'I',
      N = 'N',
      H = 'H',
    },
  })
EOF

  nnoremap <leader>q <cmd>lua require('quicker').toggle({focus = true})<CR>
endfunction

if has('nvim')
  call InitQuicker()
endif

" -----------------------------------------------------------------------------
" folke/trouble.nvim
function! InitTrouble() abort
  lua << EOF
  require('trouble').setup({
    focus = true,
    auto_refresh = false,
    auto_preview = false,
    follow = false,
    win = {
      position = 'bottom',
    },
    keys = {
      ['<c-x>'] = 'jump_split',
      ['<c-s>'] = false,
    },
    icons = {
      indent = {
        fold_open     = '  ',
        fold_closed   = '  ',
      },
      folder_closed   = '',
      folder_open     = '',
      kinds = {
        Array         = '',
        Boolean       = '',
        Class         = '',
        Constant      = '',
        Constructor   = '',
        Enum          = '',
        EnumMember    = '',
        Event         = '',
        Field         = '',
        File          = '',
        Function      = '',
        Interface     = '',
        Key           = '',
        Method        = '',
        Module        = '',
        Namespace     = '',
        Null          = '',
        Number        = '',
        Object        = '',
        Operator      = '',
        Package       = '',
        Property      = '',
        String        = '',
        Struct        = '',
        TypeParameter = '',
        Variable      = '',
      },
    },
  })

  local function qf_next()
    if require('trouble').is_open() then
      require('trouble').next({ skip_groups = true, jump = true })
    else
      vim.cmd('cnext')
    end
  end

  local function qf_prev()
    if require('trouble').is_open() then
      require('trouble').previous({ skip_groups = true, jump = true })
    else
      vim.cmd('cprev')
    end
  end

  local function qf_first()
    if require('trouble').is_open() then
      require('trouble').first({ jump = true })
    else
      vim.cmd('cfirst')
    end
  end

  local function qf_last()
    if require('trouble').is_open() then
      require('trouble').last({ jump = true })
    else
      vim.cmd('clast')
    end
  end

  vim.keymap.set('n', ']q', qf_next, {silent = true, desc = 'Next (Trouble/QF)'})
  vim.keymap.set('n', '[q', qf_prev, {silent = true, desc = 'Prev (Trouble/QF)'})
  vim.keymap.set('n', '[Q', qf_first, { silent = true, desc = 'First (Trouble/QF)' })
  vim.keymap.set('n', ']Q', qf_last, { silent = true, desc = 'Last (Trouble/QF)' })
EOF

  highlight! link TroubleNormal Normal
  highlight! link TroubleNormalNC Normal
  highlight! link TroubleIndent IblIndent
  highlight! link TroubleIndentFoldClosed IblIndent
  highlight! link TroubleIndentFoldOpen IblIndent

  nnoremap <leader>T <cmd>lua require('trouble').toggle()<CR>
endfunction

if has('nvim')
  call InitTrouble()
endif

" -----------------------------------------------------------------------------
" chentoast/marks.nvim
function! InitMarks() abort
  lua << EOF
  require('marks').setup({
    builtin_marks = {
      "'",
      '^',
      '[',
      '<',
    },
    default_mappings = false,
    mappings = {
      set = 'm',
      set_next = 'm,',
      toggle = 'm;',
      delete = 'dm',
      delete_line = 'dm-',
    },
    excluded_filetypes = {
      'blink-cmp-menu',
      'dropbar_menu',
      'dropbar_menu_fzf',
      'DressingInput',
      'cmp_docs',
      'cmp_menu',
      'noice',
      'prompt',
      'TelescopePrompt',
      'trouble',
      'NvimTree',
      'oil',
      'aerial',
      'undotree',
      'fugitiveblame',
      'diffview',
      'qf',
    },
  })
EOF

  highlight! link MarkSignHL SignColumn
  highlight! link MarkSignNumHL SignColumn
endfunction

if has('nvim')
  call InitMarks()
endif

" -----------------------------------------------------------------------------
" lewis6991/satellite.nvim
function! InitSatellite() abort
  lua << EOF
  require('satellite').setup({
    current_only = true,
    handlers = {
      cursor = {
        enable = false,
      },
      diagnostic = {
        enable = false,
      },
      gitsigns = {
        enable = false,
      },
    },
    excluded_filetypes = {
      'blink-cmp-menu',
      'dropbar_menu',
      'dropbar_menu_fzf',
      'DressingInput',
      'cmp_docs',
      'cmp_menu',
      'noice',
      'prompt',
      'TelescopePrompt',
      'trouble',
      'NvimTree',
      'oil',
      'aerial',
      'undotree',
      'fugitiveblame',
      'diffview',
      'qf',
    },
  })
EOF

  highlight! link SatelliteSearch SatelliteMark
  highlight! link SatelliteSearchCurrent SatelliteMark
endfunction

if has('nvim')
  call InitSatellite()
endif

" -----------------------------------------------------------------------------
" RRethy/vim-illuminate
function! InitIlluminate() abort
  lua << EOF
  require('illuminate').configure({
    disable_keymaps = true,
    filetypes_denylist = {
      'TelescopePrompt',
      'trouble',
      'NvimTree',
      'oil',
      'aerial',
      'undotree',
      'fugitiveblame',
    },
  })
EOF
endfunction

if has('nvim')
  call InitIlluminate()
endif

" -----------------------------------------------------------------------------
" lukas-reineke/indent-blankline.nvim
function! InitIndentBlankline() abort
  lua << EOF
  require('ibl').setup({
    indent = {
      char = '▏',
    },
    scope = {
      enabled = false,
    },
  })
EOF
endfunction

if has('nvim')
  call InitIndentBlankline()
endif

" -----------------------------------------------------------------------------
" lukas-reineke/virt-column.nvim
function! InitVirtColumn() abort
  lua << EOF
  require('virt-column').setup({
    char = '╎',
    highlight = 'IblIndent',
  })
EOF
endfunction

if has('nvim')
  call InitVirtColumn()
endif

" -----------------------------------------------------------------------------
" rachartier/tiny-inline-diagnostic.nvim
function! InitTinyDiag() abort
  lua << EOF
  require('tiny-inline-diagnostic').setup({})

  vim.diagnostic.config({ virtual_text = false })
EOF
endfunction

if has('nvim')
  call InitTinyDiag()
endif

" -----------------------------------------------------------------------------
" j-hui/fidget.nvim
function! InitFidget() abort
  lua << EOF
  require('fidget').setup({
    notification = {
      window = {
        winblend = 0,
      },
      view = {
        stack_upwards = false,
      },
    },
  })

  vim.notify = require('fidget').notify
EOF
endfunction

if has('nvim')
  call InitFidget()
endif

" -----------------------------------------------------------------------------
" folke/which-key.nvim or liuchengxu/vim-which-key
function! InitWhichKeyNvim() abort
  lua << EOF
  require('which-key').setup({
    preset = 'helix',
    win = {
      width = 80,
    },
    delay = function(ctx)
      return ctx.plugin and 0 or 500
    end,
    icons = {
      mappings = false,
      keys = {
        Up = '<Up>',
        Down = '<Down>',
        Left = '<Left>',
        Right = '<Right>',
        C = '<C>',
        M = '<M>',
        D = '<D>',
        S = '<S>',
        CR = '<CR>',
        Esc = '<Esc>',
        ScrollWheelDown = '<ScrollWheelDown>',
        ScrollWheelUp = '<ScrollWheelUp>',
        NL = '<NL>',
        BS = '<BS>',
        Space = '<Space>',
        Tab = '<Tab>',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
        F9 = '<F9>',
        F10 = '<F10>',
        F11 = '<F11>',
        F12 = '<F12>',
      },
    },
  })
EOF

  nnoremap <leader>? <cmd>WhichKey<cr>
endfunction

function! InitWhichKeyVim() abort
  nnoremap <leader>? :WhichKey
endfunction

if has('nvim')
  call InitWhichKeyNvim()
else
  call InitWhichKeyVim()
endif

" -----------------------------------------------------------------------------
" okuuva/auto-save.nvim or 907th/vim-auto-save
function! InitAutosaveNvim() abort
  lua << EOF
  require('auto-save').setup({
    lockmarks = true,
    condition = function(buf)
      local filetype = vim.fn.getbufvar(buf, '&filetype')
      if vim.list_contains({ 'oil', 'qf' }, filetype) then
        return false
      end
      return true
    end
  })
EOF
endfunction

function! InitAutosaveVim() abort
  let g:auto_save = 1
  let g:auto_save_silent = 1
endfunction

if has('nvim')
  call InitAutosaveNvim()
else
  call InitAutosaveVim()
endif

" -----------------------------------------------------------------------------
" ahmedkhalf/project.nvim
function! InitProjectNvim() abort
  lua << EOF
  require('project_nvim').setup({
    detection_methods = {
      'pattern',
    },
    patterns = {
      '.git',
      '_darcs',
      '.hg',
      '.bzr',
      '.svn',
    },
    scope_chdir = 'tab',
    silent_chdir = false,
  })
EOF
endfunction

if has('nvim')
  call InitProjectNvim()
endif

" -----------------------------------------------------------------------------
" moll/vim-bbye
function! InitBbye() abort
  cnoreabbrev bq Bdelete
  cnoreabbrev bd Bdelete
  nnoremap <c-q> <cmd>Bdelete<cr>
  nnoremap <c-w>Q <cmd>Bdelete<cr>
endfunction

if ! has('nvim')
  call InitBbye()
endif

" -----------------------------------------------------------------------------
" vim-scripts/BufOnly.vim
function! InitBufOnly() abort
  cnoreabbrev bo silent BufOnly
  cnoreabbrev bon silent BufOnly
  cnoreabbrev bonly silent BufOnly
  nnoremap <c-w>O <cmd>BufOnly<cr>
endfunction

if ! has('nvim')
  call InitBufOnly()
endif

" -----------------------------------------------------------------------------
" Shatur/neovim-session-manager
function! InitSessionManager() abort
  lua << EOF
  local config = require('session_manager.config')
  require('session_manager').setup({
    autoload_mode = { config.AutoloadMode.Disabled },
    autosave_only_in_session = true,
    load_include_current = true,
  })
EOF
endfunction

if has('nvim')
  call InitSessionManager()
endif

" -----------------------------------------------------------------------------
" nvim-telescope/telescope.nvim
function! InitTelescope() abort
  lua << EOF
  require('telescope').setup({
    defaults = {
      mappings = {
        n = {
          ['q'] = require('telescope.actions').close,
          ['<C-Down>'] = require('telescope.actions').cycle_history_next,
          ['<C-Up>'] = require('telescope.actions').cycle_history_prev,
          ['<C-t>'] = require('trouble.sources.telescope').open,
          ['<C-p>'] = require('telescope.actions.layout').toggle_preview,
        },
        i = {
          ['<C-Down>'] = require('telescope.actions').cycle_history_next,
          ['<C-Up>'] = require('telescope.actions').cycle_history_prev,
          ['<C-t>'] = require('trouble.sources.telescope').open,
          ['<C-p>'] = require('telescope.actions.layout').toggle_preview,
        },
      },
      initial_mode = 'insert',
      sorting_strategy = 'ascending',
      disable_devicons = true,
      dynamic_preview_title = true,
      set_env = {
        LESS = '',
        DELTA_PAGER = 'less',
      },
    },
    pickers = {
      find_files = {
        hidden = true,
        mappings = {
          n = {
            ['<C-i>'] = function () require('telescope.builtin').find_files({ no_ignore = true }) end,
          },
          i = {
            ['<C-i>'] = function () require('telescope.builtin').find_files({ no_ignore = true }) end,
          },
        },
      },
      buffers = {
        show_all_buffers = false,
        sort_buffers = function (a, b)
          local index_of = require('barbar.utils.list').index_of
          local state = require('barbar.state')
          return index_of(state.buffers, a) < index_of(state.buffers, b)
        end,
        select_current = true,
      },
      jumplist = {
        show_line = false,
      },
      lsp_definitions = {
        fname_width = 60,
      },
      lsp_implementations = {
        fname_width = 60,
      },
      lsp_type_definitions = {
        fname_width = 60,
      },
      lsp_references = {
        fname_width = 60,
        include_current_line = false,
      },
      lsp_dynamic_workspace_symbols = {
        fname_width = 60,
        ignore_symbols = { 'variable', 'field' },
      },
    },
    extensions = {
      ['ui-select'] = vim.tbl_extend('force', require('telescope.themes').get_cursor({
        layout_config = {
          height = 15+4,
        },
      }), {
      }),
      recent_files = {
        stat_files = false,
        only_cwd = true,
        show_current_file = true,
        ignore_patterns = {
          '/tmp/',
          'Scratch',
          'Bqf',
          'quickfix',
          'trouble',
          'NvimTree_',
          'oil',
          'aerial',
          'undotree',
          'Grug',
          'guihua',
          'gitsigns',
          'fugitiveblame',
          'flog',
          'CodeCompanion',
          'Plugins',
          'COMMIT_',
          '-todo$',
        },
      },
      live_grep_args = {
        mappings = {
          n = {
            ['<C-k>'] = require('telescope-live-grep-args.actions').quote_prompt(),
            ['<C-f>'] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = ' -F ' }),
            ['<C-i>'] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = ' -u ' }),
            ['<C-y>'] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = ' -t ' }),
            ['<C-g>'] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = ' -g ' }),
          },
          i = {
            ['<C-k>'] = require('telescope-live-grep-args.actions').quote_prompt(),
            ['<C-f>'] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = ' -F ' }),
            ['<C-i>'] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = ' -u ' }),
            ['<C-y>'] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = ' -t ' }),
            ['<C-g>'] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = ' -g ' }),
          },
        },
      },
      hierarchy = {
        disable_devicons = true,
      },
      aerial = {
        show_columns = 'symbols',
      },
    },
  })
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('ui-select')
  require('telescope').load_extension('recent_files')
  require('telescope').load_extension('live_grep_args')
  require('telescope').load_extension('dir')
  require('telescope').load_extension('telescope-tabs')
  require('telescope-tabs').setup({
    close_tab_shortcut_i = '<M-d>',
    close_tab_shortcut_n = '<M-d>',
  })
  require('telescope').load_extension('yank_history')
  require('telescope').load_extension('aerial')
  require('telescope').load_extension('hierarchy')

  -- https://github.com/nvim-telescope/telescope.nvim/issues/605
  local actions = require('telescope.actions')
  local previewers = require('telescope.previewers')
  local builtin = require('telescope.builtin')
  local M = {}
  local git_status_previewer = previewers.new_termopen_previewer({
    get_command = function(entry)
      if entry.status == '??' or 'A ' then
          return { 'git', '-c', 'core.pager=delta', '-c', 'delta.paging=always', 'diff', '--no-ext-diff', entry.value }
      end
      return { 'git', '-c', 'core.pager=delta', '-c', 'delta.paging=always', 'diff', '--no-ext-diff', entry.value .. '^!' }
    end
  })
  local git_commits_previewer = previewers.new_termopen_previewer({
    get_command = function(entry)
      if entry.status == '??' or 'A ' then
          return { 'git', '-c', 'core.pager=delta', '-c', 'delta.paging=always', 'show', '--no-ext-diff', entry.value }
      end
      return { 'git', '-c', 'core.pager=delta', '-c', 'delta.paging=always', 'show', '--no-ext-diff', entry.value .. '^!' }
    end
  })
  M.git_status = function(opts)
      opts = opts or {}
      opts.previewer = git_status_previewer
      builtin.git_status(opts)
  end
  M.git_bcommits = function(opts)
      opts = opts or {}
      opts.previewer = git_commits_previewer
      builtin.git_bcommits(opts)
  end
  M.git_commits = function(opts)
      opts = opts or {}
      opts.previewer = git_commits_previewer
      builtin.git_commits(opts)
  end
  vim.keymap.set('n', '<leader>ge', M.git_status, { desc = 'Telescope git_status' })

  vim.keymap.set('n', 'gf', function()
    require('telescope.builtin').find_files({ default_text = vim.fn.expand('<cword>') })
  end, { noremap = true, silent = true, desc = 'Find files with word under cursor' })
  vim.keymap.set('v', 'gf', function()
    vim.cmd('normal! "vy')
    require('telescope.builtin').find_files({ default_text = vim.fn.getreg('v') })
  end, { noremap = true, silent = true, desc = 'Find files with selected text' })
  vim.keymap.set('v', '<leader>f', function()
    vim.cmd('normal! "vy')
    require('telescope.builtin').find_files({ default_text = vim.fn.getreg('v') })
  end, { noremap = true, silent = true, desc = 'Find files with selected text' })

  require('import').setup({
    picker = 'telescope',
  })
EOF

  nnoremap gd <cmd>Telescope lsp_definitions<cr>
  nnoremap gD <cmd>Telescope lsp_implementations<cr>
  nnoremap gy <cmd>Telescope lsp_type_definitions<cr>
  nnoremap ge <cmd>Telescope lsp_references<cr>
  nnoremap gE <cmd>Telescope hierarchy disable_devicons=true<cr>
  nnoremap gs <cmd>lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()<cr>
  nnoremap <leader>e <cmd>lua require('telescope').extensions.recent_files.pick()<cr>
  nnoremap <leader>E <cmd>Telescope jumplist<cr>
  nnoremap <leader>f <cmd>Telescope find_files<cr>
  nnoremap <leader>Ff <cmd>Telescope dir find_files<cr>
  nnoremap <leader>s <cmd>Telescope live_grep_args<cr>
  vnoremap <leader>s <cmd>lua require('telescope-live-grep-args.shortcuts').grep_visual_selection()<cr>
  vnoremap gs <cmd>lua require('telescope-live-grep-args.shortcuts').grep_visual_selection()<cr>
  nnoremap <leader>Fs <cmd>Telescope dir live_grep<cr>
  nnoremap <leader>b <cmd>Telescope buffers<cr>
  nnoremap <leader>B <cmd>Telescope telescope-tabs list_tabs<cr>
  nnoremap <leader>y <cmd>Telescope yank_history<cr>
  nnoremap <leader>k <cmd>Telescope aerial initial_mode=insert<cr>
  nnoremap <leader>K <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
  nnoremap <leader>d <cmd>Telescope diagnostics bufnr=0<CR>
  nnoremap <leader>D <cmd>Telescope diagnostics<CR>
  nnoremap <leader>Q <cmd>Telescope quickfixhistory<cr>
  nnoremap <leader>gb <cmd>Telescope git_branches<cr>
  nnoremap <leader>i <cmd>Import<cr>
  nnoremap <leader>' <cmd>Telescope marks<cr>
  nnoremap <leader>` <cmd>Telescope marks<cr>
  nnoremap <leader>" <cmd>Telescope registers<cr>
  nnoremap <leader>. <cmd>Telescope resume<cr>
endfunction

if has('nvim')
  call InitTelescope()
endif

" -----------------------------------------------------------------------------
" stevearc/oil.nvim
function! InitOil() abort
  lua << EOF
  local M = {}

  function M.launch_live_grep(opts)
    return M.launch_telescope('live_grep', opts)
  end

  function M.launch_find_files(opts)
    return M.launch_telescope('find_files', opts)
  end

  function M.launch_telescope(func_name, opts)
    local basedir = require('oil').get_current_dir()
    if basedir then
      basedir = basedir:gsub('oil://', '')
      opts = opts or {}
      opts.cwd = basedir
      opts.search_dirs = { basedir }
      require('telescope.builtin')[func_name](opts)
    end
  end

  require('oil').setup({
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ['q'] = { 'actions.close', mode = 'n' },
      ['<C-x>'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-h>'] = false,
      ['<C-f>'] = { callback = function() M.launch_find_files() end, desc = 'Launch Find Files' },
      ['<C-s>'] = { callback = function() M.launch_live_grep() end, desc = 'Launch Live Grep' },
    },
  })
EOF

  nnoremap - <cmd>Oil<CR>
endfunction

if has('nvim')
  call InitOil()
endif

" -----------------------------------------------------------------------------
" nvim-tree/nvim-tree.lua
function! InitNvimTree() abort
  lua << EOF
  local api = require('nvim-tree.api')
  local openfile = require('nvim-tree.actions.node.open-file')
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  local M = {}

  local view_selection = function(prompt_bufnr, map)
    actions.select_default:replace(function()
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      local filename = selection.filename
      if (filename == nil) then
        filename = selection[1]
      end
      openfile.fn('preview', filename)
    end)
    return true
  end

  function M.launch_live_grep(opts)
    return M.launch_telescope('live_grep', opts)
  end

  function M.launch_find_files(opts)
    return M.launch_telescope('find_files', opts)
  end

  function M.launch_telescope(func_name, opts)
    local node = api.tree.get_node_under_cursor()
    local is_folder = node.fs_stat and node.fs_stat.type == 'directory' or false
    local basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ':h')
    if (node.name == '..' and TreeExplorer ~= nil) then
      basedir = TreeExplorer.cwd
    end
    opts = opts or {}
    opts.cwd = basedir
    opts.search_dirs = { basedir }
    opts.attach_mappings = view_selection
    require('telescope.builtin')[func_name](opts)
  end

  require('nvim-tree').setup({
    renderer = {
      icons = {
        show = {
          file = false,
          folder = false,
          folder_arrow = false,
          git = false,
          modified = false,
          hidden = false,
          diagnostics = false,
          bookmarks = true,
        },
        glyphs = {
          bookmark = 'M',
        },
      },
      indent_markers = {
        enable = true,
      },
    },
    view = {
      width = 30,
    },
    git = {
      enable = false,
    },
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    filters = {
      enable = true,
      git_ignored = true,
      dotfiles = false,
      custom = { '^.git$' },
    },
    actions = {
      open_file = {
        quit_on_open = false,
        window_picker = {
          enable = true,
          picker = function ()
            return require('window-picker').pick_window({
              filter_rules = {
                bo = {
                  filetype = {
                    'NvimTree',
                    'aerial',
                    'trouble',
                  },
                  buftype = {
                    'terminal',
                  },
                },
              },
            })
          end,
        },
      },
    },
    on_attach = function (bufnr)
      local api = require('nvim-tree.api')

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, silent = true, nowait = true }
      end

      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.set('n', '<c-f>', M.launch_find_files, opts('Launch Find Files'))
      vim.keymap.set('n', '<c-s>', M.launch_live_grep, opts('Launch Live Grep'))
      vim.keymap.set('n', 's', '<Plug>Sneak_s', opts('Sneak'))
      vim.keymap.set('n', 'S', '<Plug>Sneak_S', opts('Sneak'))
      vim.keymap.set('n', 'gs', api.node.run.system, opts('Run System'))
    end,
  })
EOF

  highlight! link NvimTreeNormal Normal
  highlight! link NvimTreeNormalNC NormalNC
  highlight! link NvimTreeWinSeparator WinSeparator
  highlight! link NvimTreeWinSeparator WinSeparator
  highlight! link NvimTreeIndentMarker IblIndent
endfunction

function! LazyNvimTreeToggle() abort
  if ! exists('g:inited_nvim_tree')
    call InitNvimTree()
    let g:inited_nvim_tree = 1
  endif
  lua require('nvim-tree.api').tree.toggle({ find_file = true, focus = false })
endfunction

function! LazyNvimTreeFocus() abort
  if ! exists('g:inited_nvim_tree')
    call InitNvimTree()
    let g:inited_nvim_tree = 1
  endif
  NvimTreeFocus
endfunction

function! LazyInitNvimTree() abort
  nnoremap <leader>t <cmd>call LazyNvimTreeToggle()<CR>
  nnoremap _ <cmd>call LazyNvimTreeFocus()<CR>
endfunction

if has('nvim')
  call LazyInitNvimTree()
endif

" -----------------------------------------------------------------------------
" rgroli/other.nvim
function! InitOther() abort
  lua << EOF
  require('other-nvim').setup({
    mappings = {
      -- h -> c
      {
        pattern = "(.+)/include/(.+)%.h$",
        target  = "%1/src/%2.c",
        context = "c",
      },
      -- c -> h
      {
        pattern = "(.+)/src/(.+)%.c$",
        target  = "%1/include/%2.h",
        context = "c",
      },
      -- h -> cpp
      {
        pattern = "(.+)/include/(.+)%.h$",
        target  = "%1/src/%2.cpp",
        context = "c",
      },
      -- cpp -> h
      {
        pattern = "(.+)/src/(.+)%.cpp$",
        target  = "%1/include/%2.h",
        context = "c",
      },

      'c',
      'golang',
      'python',
      'rust',
    },
  })
  vim.keymap.set('n', '<leader>a', '<cmd>Other<CR>')
EOF
endfunction

if has('nvim')
  call InitOther()
endif

" -----------------------------------------------------------------------------
" stevearc/aerial.nvim
function! InitAerial() abort
  lua << EOF
  require('aerial').setup({
    layout = {
      placement = 'edge',
      default_direction = 'left',
      min_width = 30,
      width = 30,
    },
    attach_mode = 'global',
    nerd_font = false,
    use_icon_provider = false,
    close_on_select = false,
    autojump = true,
    show_guides = true,
    disable_max_lines = 99999,
    disable_max_size = 1000 * 1024,
  })
EOF

  highlight! link AerialLine CursorLine
  highlight! link AerialGuide IblIndent

  nnoremap <leader>o <cmd>AerialToggle!<cr>
endfunction

if has('nvim')
  call InitAerial()
endif

" -----------------------------------------------------------------------------
" MagicDuck/grug-far.nvim
function! InitGrugFar() abort
  lua << EOF
  require('grug-far').setup({
    instanceName = 'grug-far',
    normalModeSearch = true,
    startInInsertMode = false,
    transient = true,
    icons = {
      enabled = false,
    },
    history = {
      maxHistoryLines = 1000,
    },
  })
EOF

  nnoremap <leader>S <cmd>lua require('grug-far').kill_instance() require('grug-far').open()<cr>
  vnoremap <leader>S <cmd>lua require('grug-far').kill_instance() require('grug-far').with_visual_selection()<cr>
endfunction

if has('nvim')
  call InitGrugFar()
endif

" -----------------------------------------------------------------------------
" nvim-treesitter/nvim-treesitter
function! InitTreesitter() abort
  lua << EOF
  -- https://github.com/neovim/neovim/issues/32660
  vim.g._ts_force_sync_parsing = true

  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'c',
      'cpp',
      'cmake',
      'go',
      'python',
      'perl',
      'ruby',
      'lua',
      'rust',
      'bash',
      'make',
      'html',
      'css',
      'javascript',
      'typescript',
      'tsx',
      'jinja',
      'sql',
      'json',
      'yaml',
      'toml',
      'xml',
      'dockerfile',
      'vim',
      'markdown',
      'diff',
      'gitcommit',
      'git_rebase',
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 1000 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end

        local disable_langs = {
          'mermaid',
          'csv',
          'tsv',
          'puppet',
        }
        for _, s in ipairs(disable_langs) do
          if s == lang then
              return true
          end
        end
      end,
    },
    indent = {
      enable = false,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
          ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },
          ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
          ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },
          ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
          ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },
          ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
          ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },
          ['am'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
          ['im'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },
          ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
          ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['cm'] = '@parameter.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']f'] = { query = '@call.outer', desc = 'Next function call start' },
          [']m'] = { query = '@function.outer', desc = 'Next method/function def start' },
          [']c'] = { query = '@class.outer', desc = 'Next class start' },
          [']i'] = { query = '@conditional.outer', desc = 'Next conditional start' },
          [']l'] = { query = '@loop.outer', desc = 'Next loop start' },
        },
        goto_next_end = {
          [']F'] = { query = '@call.outer', desc = 'Next function call end' },
          [']M'] = { query = '@function.outer', desc = 'Next method/function def end' },
          [']C'] = { query = '@class.outer', desc = 'Next class end' },
          [']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
          [']L'] = { query = '@loop.outer', desc = 'Next loop end' },
        },
        goto_previous_start = {
          ['[f'] = { query = '@call.outer', desc = 'Prev function call start' },
          ['[m'] = { query = '@function.outer', desc = 'Prev method/function def start' },
          ['[c'] = { query = '@class.outer', desc = 'Prev class start' },
          ['[i'] = { query = '@conditional.outer', desc = 'Prev conditional start' },
          ['[l'] = { query = '@loop.outer', desc = 'Prev loop start' },
        },
        goto_previous_end = {
          ['[F'] = { query = '@call.outer', desc = 'Prev function call end' },
          ['[M'] = { query = '@function.outer', desc = 'Prev method/function def end' },
          ['[C'] = { query = '@class.outer', desc = 'Prev class end' },
          ['[I'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
          ['[L'] = { query = '@loop.outer', desc = 'Prev loop end' },
        },
      },
    },
  })
EOF
endfunction

if has('nvim')
  call InitTreesitter()
endif

" -----------------------------------------------------------------------------
" RRethy/vim-hexokinase
function! InitHexokinase() abort
  let g:Hexokinase_ftEnabled = []
  let g:Hexokinase_highlighters = ['virtual']
endfunction

if has('nvim')
  call InitHexokinase()
endif

" -----------------------------------------------------------------------------
" ray-x/go.nvim
function! InitGo() abort
  lua << EOF
  require('go').setup({
    lsp_keymaps = false,
    lsp_codelens = false,
    lsp_document_formatting = false,
    lsp_inlay_hints = {
      enable = false,
    },
    textobjects = false,
    diagnostic = false,
    dap_debug = false,
    dap_debug_keymap = false,
    dap_debug_vt = false,
    lsp_gofumpt = false,
    luasnip = true,
    tag_options = '',
    comment_placeholder = '',
    icons = false,
  })
EOF
endfunction

if has('nvim')
  call InitGo()
endif

" -----------------------------------------------------------------------------
" MeanderingProgrammer/render-markdown.nvim
function! InitRenderMarkdown() abort
  lua << EOF
  require('render-markdown').setup({
    preset = 'obsidian',
    completions = {
      lsp = {
        enabled = true,
      },
    },
    max_file_size = 1,
    heading = {
      sign = false,
      position = 'inline',
      width = 'block',
    },
    code = {
      sign = false,
      conceal_delimiters = false,
      language = false,
      border = 'thin',
      width = 'block',
    },
    file_types = {
      'markdown',
      'codecompanion',
    },
  })
EOF
endfunction

if has('nvim')
  call InitRenderMarkdown()
endif

" -----------------------------------------------------------------------------
" hat0uma/csvview.nvim
function! InitCsvView() abort
  lua << EOF
  require('csvview').setup({
    view = {
      display_mode = 'border',
    },
    keymaps = {
      textobject_field_inner = { 'if', mode = { 'o', 'x' } },
      textobject_field_outer = { 'af', mode = { 'o', 'x' } },
      jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
      jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
      jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
      jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
    },
  })
EOF
endfunction

if has('nvim')
  autocmd User csvview.nvim call InitCsvView()
endif

" -----------------------------------------------------------------------------
" rodjek/vim-puppet
function! BufInitPuppet() abort
  set ft=puppet
endfunction

if has('nvim')
  autocmd BufEnter *.pp call BufInitPuppet()
endif

" -----------------------------------------------------------------------------
" akinsho/toggleterm.nvim
function! InitToggleterm() abort
  lua << EOF
  require('toggleterm').setup({
    open_mapping = [[<c-\><c-\>]],
    autochdir = true,
    shade_terminals = false,
  })

  function _G.set_terminal_keymaps()
    local opts = {buffer = 0}
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  end
  vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
EOF
endfunction

if has('nvim')
  call InitToggleterm()
endif

" -----------------------------------------------------------------------------
" stevearc/overseer.nvim
function! InitOverseer() abort
  lua << EOF
  require('overseer').setup({
    strategy = {
      'toggleterm',
      use_shell = true,
    }
  })
EOF
endfunction

if has('nvim')
  call InitOverseer()
endif

" -----------------------------------------------------------------------------
" sindrets/diffview.nvim
function! InitDiffview() abort
  lua << EOF
  require('diffview').setup({
    enhanced_diff_hl = true,
    use_icons = false,
    icons = {
      folder_closed = '',
      folder_open = '',
    },
    signs = {
      fold_closed = '',
      fold_open = '',
    },
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'DiffviewFile',
    callback = function()
      vim.keymap.set('n', ']h', ']c', { buffer = true, silent = true })
      vim.keymap.set('n', '[h', '[c', { buffer = true, silent = true })
    end,
  })
EOF

  nnoremap <leader>gd <cmd>DiffviewOpen<cr>
  nnoremap <leader>gD <cmd>DiffviewFileHistory %<cr>
endfunction

if has('nvim')
  call InitDiffview()
endif

" -----------------------------------------------------------------------------
" kdheepak/lazygit.nvim
function! InitLazyGit() abort
  let g:lazygit_floating_window_use_plenary = 1

  nnoremap <leader>gg <cmd>LazyGit<cr>
endfunction

if has('nvim')
  call InitLazyGit()
endif

" -----------------------------------------------------------------------------
" harrisoncramer/gitlab.nvim
function! InitGitlabNvim() abort
  lua << EOF
  require('gitlab').setup({
    keymaps = {
      global = {
        disable_all = true,
      },
    },
  })
EOF

  command! GitlabReview lua require('gitlab').review()
  command! GitlabChooseMR lua require('gitlab').choose_merge_request()
endfunction

function! LazyInitGitlabNvim() abort
  command! GitlabReview lua vim.call('InitGitlabNvim') require('gitlab').review()
  command! GitlabChooseMR lua vim.call('InitGitlabNvim') require('gitlab').choose_merge_request()
endfunction

if has('nvim')
  call LazyInitGitlabNvim()
endif


" =============================================================================
" own commands

" -----------------------------------------------------------------------------
" yank file line reference
command YankFilename let @+ = substitute(expand('%'), getcwd() . '/', '', '')
command YankReference let @+ = join([substitute(expand('%'), getcwd() . '/', '', ''), line('.')], ':')

function! s:YankReferenceRange(line_start, line_end) abort
  let l:start = min([a:line_start, a:line_end])
  let l:end = max([a:line_start, a:line_end])
  let l:file = substitute(expand('%'), getcwd() . '/', '', '')
  let @+ = printf('%s:%d-%d', l:file, l:start, l:end)
endfunction
command -range YankReferenceRange call <SID>YankReferenceRange(<line1>, <line2>)

" -----------------------------------------------------------------------------
" sublime text integration
if has('nvim')
  lua << EOF
  vim.api.nvim_create_user_command('Subl',
    function (opts)
      if opts.fargs[1] == 'dir' then
        vim.cmd('!subl "' .. vim.fn.getcwd() .. '"')
      else
        vim.cmd('!subl "%":' .. vim.fn.line('.'))
      end
    end,
    {
      desc = 'Open in Sublime Text',
      nargs = '?',
      complete = function ()
        return {'dir'}
      end,
    }
  )
EOF
endif

" -----------------------------------------------------------------------------
" sublime merge integration
if has('nvim')
  lua << EOF
  vim.api.nvim_create_user_command('Smerge',
    function (opts)
      if opts.fargs[1] == 'blame' then
        vim.cmd('!smerge blame "%"')
      elseif opts.fargs[1] == 'log' then
        vim.cmd('!smerge log "%"')
      else
        vim.cmd('!smerge "' .. vim.fn.getcwd() .. '"')
      end
    end,
    {
      desc = 'Open in Sublime Merge',
      nargs = '?',
      complete = function ()
        return {'dir', 'blame', 'log'}
      end,
    }
  )
EOF
endif

" -----------------------------------------------------------------------------
" cursor integration
if has('nvim')
  lua << EOF
  vim.api.nvim_create_user_command('Cursor',
    function (opts)
      if opts.fargs[1] == 'dir' then
        vim.cmd('!cursor "' .. vim.fn.getcwd() .. '"')
      else
        local dir = vim.fn.getcwd()
        if dir == (vim.loop.os_homedir or vim.uv.os_homedir)() then
          dir = ''
        end
        vim.cmd('!cursor "' .. dir .. '" -g "' .. vim.fn.expand('%:p') .. '":' .. vim.fn.line('.'))
      end
    end,
    {
      desc = 'Open in Cursor',
      nargs = '?',
      complete = function ()
        return {'dir'}
      end,
    }
  )
EOF
endif


" =============================================================================
" vim mappings
" https://nanotipsforvim.prose.sh/esc-in-normal-mode
nnoremap <silent> <cr> <cmd>echo<cr>

function! s:empty_message(timer)
  if mode() ==# 'n'
    echon ''
  endif
endfunction

let s:clear_msg_timer = -1

function! s:clear_message_after(ms) abort
  if s:clear_msg_timer != -1
    call timer_stop(s:clear_msg_timer)
  endif
  let s:clear_msg_timer = timer_start(a:ms, funcref('s:empty_message'))
endfunction

if has('nvim')
  augroup cmd_msg_cls
    autocmd!
    autocmd CmdlineLeave : call s:clear_message_after(3000)
    autocmd TextYankPost * call s:clear_message_after(3000)
    autocmd TextChanged,TextChangedI * call s:clear_message_after(3000)
  augroup END
endif

" https://stackoverflow.com/a/51388837/1600438
if ! has('nvim')
  nnoremap <esc>^[ <esc>^[
endif
nunmap <esc>

" https://bluz71.github.io/2021/09/10/vim-tips-revisited.html#smarter-j-and-k-navigation
nnoremap <silent> <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <silent> <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

" https://superuser.com/a/836924/2151180
nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>
nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>

" https://www.reddit.com/r/neovim/comments/sf0hmc/im_really_proud_of_this_mapping_i_came_up_with/
nnoremap c. /\V\C<C-r>"<CR>cgn<C-a><Esc>
nnoremap d. /\V\C<C-r>"<CR>dgn

" https://vim.fandom.com/wiki/Comfortable_handling_of_registers
nnoremap [+ <cmd>let @"=@+<CR>
nnoremap ]+ <cmd>let @+=@"<CR>

nmap +c "+c
nmap +C "+C
nmap +d "+d
nmap +D "+D
nmap +x "+x
nmap +X "+X
nmap +y "+y
nmap +Y "+Y
nmap +p "+p
nmap +P "+P
nmap +]p "+]p
nmap +[p "+[p
nmap +]P "+]P
nmap +[P "+[P
nmap +>p "+>p
nmap +<p "+<p
nmap +>P "+>P
nmap +<P "+<P
nmap +=p "+=p
nmap +=P "+=P

vmap +c "+c
vmap +C "+C
vmap +d "+d
vmap +D "+D
vmap +x "+x
vmap +X "+X
vmap +y "+y
vmap +Y "+Y
vmap +p "+p
vmap +P "+P
vmap +]p "+]p
vmap +[p "+[p
vmap +]P "+]P
vmap +[P "+[P
vmap +>p "+>p
vmap +<p "+<p
vmap +>P "+>P
vmap +<P "+<P
vmap +=p "+=p
vmap +=P "+=P

" https://gist.github.com/romainl/d2ad868afd7520519057475bd8e9db0c
function! Format(type, ...)
  normal! '[v']gq
  if v:shell_error > 0
    silent undo
    redraw
    echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
  endif
  if exists('w:gqview')
    call winrestview(w:gqview)
    unlet w:gqview
  endif
endfunction
nmap <silent> gq :let w:gqview = winsaveview()<CR>:set opfunc=Format<CR>g@

nmap gqq gq_

" https://www.reddit.com/r/neovim/comments/lchm1o/comment/glzx6zf/
onoremap <silent> ie :silent normal ggVG<CR>
xnoremap <silent> ie :<c-u>silent normal ggVG<CR>

" https://bluz71.github.io/2021/09/10/vim-tips-revisited.html#fast-previous-buffer-switching
nnoremap <C-Backspace> <C-^>
nnoremap <C-S-Backspace> <cmd>lua require('telescope-tabs').go_to_previous()<cr>

nnoremap <C-w>^ <cmd>vsplit #<cr>
nnoremap <C-w><C-^> <cmd>vsplit #<cr>
nnoremap <C-w><Backspace> <cmd>vsplit #<cr>
nnoremap <C-w><C-Backspace> <cmd>vsplit #<cr>
nnoremap <silent> <C-w>n :vsplit<cr>:enew<cr>
nnoremap <silent> <C-w><C-n> :vsplit<cr>:enew<cr>
nnoremap <C-w>t <C-w>s<C-w>T

cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-F> <C-right>
cnoremap <C-B> <C-left>
inoremap <A-left> <C-left>
inoremap <A-right> <C-right>
cnoremap <A-left> <C-left>
cnoremap <A-right> <C-right>

cnoreabbrev E e
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev Wqa wqa
cnoreabbrev w!! w !sudo tee % >/dev/null
cnoreabbrev tabq tabclose
cnoreabbrev tq tabclose
cnoreabbrev tonly tabonly
cnoreabbrev ton tabonly
cnoreabbrev to tabonly
cnoreabbrev tnew tabnew
nnoremap ZT <cmd>tabclose<cr>
nnoremap ZA <cmd>wqa<cr>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-Up> <cmd>resize +2<cr>
nnoremap <C-Down> <cmd>resize -2<cr>
nnoremap <C-Right> <cmd>vertical resize +2<cr>
nnoremap <C-Left> <cmd>vertical resize -2<cr>


" =============================================================================
" vim settings

" -----------------------------------------------------------------------------
" appearance
set number
set relativenumber
set cursorline
set colorcolumn=80,120
set scrolloff=3
set sidescroll=1

set nowrap

set mouse=a

set shortmess+=aIT
if v:version > 704
  set shortmess+=F
endif
if has('patch-7.4.314')
  set shortmess+=c
endif
set noshowmode
set title
if has('nvim')
  set titlestring=%{substitute(getcwd(),$HOME,'~','')}\ -\ NVIM
else
  set titlestring=%{substitute(getcwd(),$HOME,'~','')}\ -\ VIM
endif
if ! has('nvim')
  " https://vi.stackexchange.com/questions/8406/how-to-restore-bash-terminal-title-if-using-set-title-in-vim
  set titleold=
endif
set confirm
if exists('+signcolumn')
  set signcolumn=yes
endif
set breakindent
set breakindentopt=sbr
set showbreak=↪
let g:vimsyn_embed = 'l'
if has('nvim')
  set listchars=tab:→\ ,space:·,trail:·,extends:⟩,precedes:⟨,nbsp:␣
  set nolist
  augroup ShowWhitespaceInVisual
    autocmd!
    autocmd ModeChanged *:[vV␖] set list | lua require('ibl').refresh_all()
    autocmd ModeChanged [vV␖]:* set nolist | lua require('ibl').refresh_all()
  augroup END
endif

" -----------------------------------------------------------------------------
" editing
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab

set autoindent
set copyindent
set smartindent
set formatoptions+=cro
if v:version > 704
  set fixendofline
endif
if v:version >= 802
  set nrformats+=unsigned
endif

set nospell

set completeopt=menu,menuone,preview
set foldlevelstart=999
set whichwrap+=b,s,h,l,<,>
set updatetime=300

set splitright
set splitbelow

set hidden
set autoread
set autowriteall
set undofile
set undolevels=200
set nobackup
set nowritebackup
set noswapfile
if has('nvim')
  set history=1000
  set shada=s100,!,h,<100,:1000,'10000

  " https://vi.stackexchange.com/a/24564
  augroup SHADA
    autocmd!
    " autocmd FocusGained * lua vim.defer_fn(function() vim.cmd('silent! rshada') end, 100)
    " autocmd FocusLost,TextYankPost,VimLeavePre * silent! wshada
    autocmd FocusLost,VimLeavePre * silent! wshada
  augroup END
endif

" -----------------------------------------------------------------------------
" navigation
set ignorecase
set smartcase
set hlsearch

" https://noahfrederick.com/log/vim-streamlining-grep
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() =~# '^grep')  ? 'silent grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() =~# '^lgrep') ? 'silent lgrep' : 'lgrep'
augroup init_quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
augroup END

" -----------------------------------------------------------------------------
" encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp1251,latin1
set fileformats=unix,dos,mac

" -----------------------------------------------------------------------------
" other
set backupdir=~/.vim/backup
set directory=~/.vim/tmp
set undodir=~/.vim/undo
set viewdir=~/.vim/view
if &shell =~# 'fish$'
  set shell=/bin/bash
endif


" =============================================================================
" gui
if exists('g:neovide')
  language en_US
  language messages en_US
  language ctype en_US
  language time en_US
  set langmenu=en_US
  let $LANG = 'en_US'

  set guifont=Jetbrains\ Mono:h14:#e-subpixelantialias:#h-none
  set linespace=1

  lua << EOF
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0.00
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_scroll_animation_length = 0.00

  vim.keymap.set('n', '<D-s>', ':w<CR>')
  vim.keymap.set('n', '<D-w>', ':wq<CR>')
  vim.keymap.set('v', '<D-c>', '"+y')
  vim.keymap.set('n', '<D-v>', '"+P')
  vim.keymap.set('v', '<D-v>', '"+P')
  vim.keymap.set('c', '<D-v>', '<C-R>+')
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli')
  vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { silent = true })
  vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { silent = true })
  vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { silent = true })
  vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { silent = true })
EOF
endif
