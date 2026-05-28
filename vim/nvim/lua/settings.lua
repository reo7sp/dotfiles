-- -----------------------------------------------------------------------------
-- mappings

-- https://nanotipsforvim.prose.sh/esc-in-normal-mode
vim.keymap.set("n", "<cr>", "<cmd>echo<cr>", { silent = true, })

local clear_msg_timer = -1
local function empty_message()
  if vim.fn.mode() == "n" then
    vim.api.nvim_echo({ { "" } }, false, {})
  end
end

local function clear_message_after(ms)
  if clear_msg_timer ~= -1 then
    vim.fn.timer_stop(clear_msg_timer)
  end
  clear_msg_timer = vim.fn.timer_start(ms, empty_message)
end

vim.api.nvim_create_augroup("cmd_msg_cls", {
  clear = true,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = "cmd_msg_cls",
  pattern = ":",
  callback = function() clear_message_after(3000) end,
})
vim.api.nvim_create_autocmd({ "TextYankPost", "TextChanged", "TextChangedI" }, {
  group = "cmd_msg_cls",
  pattern = "*",
  callback = function() clear_message_after(3000) end,
})

-- https://bluz71.github.io/2021/09/10/vim-tips-revisited.html#smarter-j-and-k-navigation
vim.keymap.set("n", "j", function()
  if vim.v.count == 0 then
    return "gj"
  end
  return (vim.v.count > 5 and "m'" or "") .. vim.v.count .. "j"
end, {
  expr = true,
  silent = true,
})
vim.keymap.set("n", "k", function()
  if vim.v.count == 0 then
    return "gk"
  end
  return (vim.v.count > 5 and "m'" or "") .. vim.v.count .. "k"
end, {
  expr = true,
  silent = true,
})
vim.keymap.set("n", "gj", "j")
vim.keymap.set("n", "gk", "k")
vim.keymap.set("n", "<down>", "gj")
vim.keymap.set("n", "<up>", "gk")

-- https://superuser.com/a/836924/2151180
vim.keymap.set("n", "}", function()
  local count = vim.v.count1
  vim.cmd("keepjumps normal! " .. count .. "}")
end, { silent = true, })

vim.keymap.set("n", "{", function()
  local count = vim.v.count1
  vim.cmd("keepjumps normal! " .. count .. "{")
end, { silent = true, })

-- https://www.reddit.com/r/neovim/comments/sf0hmc/im_really_proud_of_this_mapping_i_came_up_with/
vim.keymap.set("n", "g.", [[/\V\C<C-r>"<CR>]])
vim.keymap.set("n", "c.", [[/\V\C<C-r>"<CR>cgn<C-a><Esc>]])
vim.keymap.set("n", "d.", [[/\V\C<C-r>"<CR>dgn]])

-- https://www.reddit.com/r/vim/comments/rctvgk/a_lesser_known_built_in_feature_you_use_regularly/
vim.keymap.set("n", "gV", "`[v`]")

-- https://vim.fandom.com/wiki/Comfortable_handling_of_registers
vim.keymap.set("n", "[+", function() vim.fn.setreg("\"", vim.fn.getreg("+")) end)
vim.keymap.set("n", "]+", function() vim.fn.setreg("+", vim.fn.getreg("\"")) end)

for _, lhs in ipairs({ "c", "C", "d", "D", "x", "X", "y", "Y", "p", "P", "]p", "[p", "]P", "[P", ">p", "<p", ">P", "<P", "=p", "=P" }) do
  vim.keymap.set("n", "+" .. lhs, "\"+" .. lhs, { remap = true, })
  vim.keymap.set("v", "+" .. lhs, "\"+" .. lhs, { remap = true, })
end

for _, lhs in ipairs({ "c", "C", "d", "D", "x", "X" }) do
  vim.keymap.set("n", "_" .. lhs, "\"_" .. lhs, { remap = true, })
  vim.keymap.set("v", "_" .. lhs, "\"_" .. lhs, { remap = true, })
end

-- https://gist.github.com/romainl/d2ad868afd7520519057475bd8e9db0c
function _G.format_operator()
  vim.cmd([[normal! '[v']gq]])
  if vim.v.shell_error > 0 then
    vim.cmd("silent undo")
    vim.cmd("redraw")
    vim.api.nvim_echo({ { "formatprg \"" .. vim.o.formatprg .. "\" exited with status " .. vim.v.shell_error } }, true, {})
  end
  if vim.w.gqview then
    vim.fn.winrestview(vim.w.gqview)
    vim.w.gqview = nil
  end
end
vim.keymap.set("n", "gq", function()
  vim.w.gqview = vim.fn.winsaveview()
  vim.go.operatorfunc = "v:lua.format_operator"
  return "g@"
end, {
  expr = true,
  silent = true,
})
vim.keymap.set("n", "gqq", "gq_", { remap = true, })

-- https://www.reddit.com/r/neovim/comments/lchm1o/comment/glzx6zf/
vim.keymap.set("o", "ie", ":<c-u>silent normal ggVG<CR>", { silent = true, })
vim.keymap.set("x", "ie", ":<c-u>silent normal ggVG<CR>", { silent = true, })

-- https://bluz71.github.io/2021/09/10/vim-tips-revisited.html#fast-previous-buffer-switching
vim.keymap.set("n", "<C-Backspace>", "<C-^>")
vim.keymap.set("n", "<C-S-Backspace>", function() require("telescope-tabs").go_to_previous() end)

vim.keymap.set("n", "<C-w>^", "<cmd>vsplit #<cr>")
vim.keymap.set("n", "<C-w><C-^>", "<cmd>vsplit #<cr>")
vim.keymap.set("n", "<C-w><Backspace>", "<cmd>vsplit #<cr>")
vim.keymap.set("n", "<C-w><C-Backspace>", "<cmd>vsplit #<cr>")
vim.keymap.set("n", "<C-w>n", function() vim.cmd("vsplit"); vim.cmd("enew") end, { silent = true, })
vim.keymap.set("n", "<C-w><C-n>", function() vim.cmd("vsplit"); vim.cmd("enew") end, { silent = true, })
vim.keymap.set("n", "<C-w>t", "<C-w>s<C-w>T")
vim.keymap.set("n", "<C-w><C-t>", "<C-w>s<C-w>T")

vim.keymap.set("c", "<C-A>", "<Home>")
vim.keymap.set("c", "<C-E>", "<End>")
vim.keymap.set("c", "<C-F>", "<C-right>")
vim.keymap.set("c", "<C-B>", "<C-left>")
vim.keymap.set("i", "<A-left>", "<C-left>")
vim.keymap.set("i", "<A-right>", "<C-right>")
vim.keymap.set("c", "<A-left>", "<C-left>")
vim.keymap.set("c", "<A-right>", "<C-right>")

vim.cmd([=[
cnoreabbrev E e
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev Wqa wqa
cnoreabbrev w!! w !sudo tee % >/dev/null
cnoreabbrev tabbreak tabe %
cnoreabbrev tabb tabe %
cnoreabbrev tb tabe %
cnoreabbrev tabq tabclose
cnoreabbrev tq tabclose
cnoreabbrev tonly tabonly
cnoreabbrev ton tabonly
cnoreabbrev to tabonly
cnoreabbrev tnew tabnew
cnoreabbrev te tabe
]=])

vim.keymap.set("n", "ZT", "<cmd>tabclose<cr>")
vim.keymap.set("n", "ZA", "<cmd>wqa<cr>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
-- vim.keymap.set('n', '<C-[>', '<C-w>W')
vim.keymap.set("n", "<C-ϧ>", "<C-w>W")
vim.keymap.set("n", "<C-]>", "<C-w>w")
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>")
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>")
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>")

vim.keymap.set("c", "<c-q>", "<esc>:vimgrep /<C-r>//j %<cr>:copen<cr>", { silent = true, })

-- -----------------------------------------------------------------------------
-- appearance
vim.cmd([=[
set number
set relativenumber
set cursorline
set colorcolumn=80,120
set scrolloff=3
set sidescroll=1

set nowrap

set mouse=a

set timeoutlen=300
set ttimeoutlen=10
set shortmess+=aITFc
set noshowmode
set title
set titlestring=%{substitute(getcwd(),$HOME,'~','')}\ -\ NVIM
set confirm
set signcolumn=yes:2
set breakindent
set breakindentopt=sbr
set showbreak=↪
let g:vimsyn_embed = 'l'
set listchars=tab:→\ ,space:·,trail:·,extends:⟩,precedes:⟨,nbsp:␣
set nolist

autocmd FileType markdown setlocal wrap linebreak
]=])

-- -----------------------------------------------------------------------------
-- editing
vim.cmd([=[
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab

set autoindent
set copyindent
set smartindent
set formatoptions+=cro
set fixendofline
set nrformats+=unsigned

set nospell

set completeopt=menu,menuone,preview
set foldlevelstart=999
set whichwrap+=b,s,h,l,<,>
set updatetime=300

set splitright
set splitbelow
set diffopt+=vertical

set hidden
set autoread
set autowriteall
set undofile
set undolevels=200
set nobackup
set nowritebackup
set noswapfile
set history=1000
set shada=s100,!,h,<100,:1000,'10000

" https://vi.stackexchange.com/a/24564
augroup SHADA
  autocmd!
  " autocmd FocusGained * lua vim.defer_fn(function() vim.cmd('silent! rshada') end, 100)
  " autocmd FocusLost,TextYankPost,VimLeavePre * silent! wshada
  autocmd FocusLost,VimLeavePre * silent! wshada
augroup END
]=])

-- -----------------------------------------------------------------------------
-- navigation
vim.cmd([=[
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
]=])

-- -----------------------------------------------------------------------------
-- encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "cp1251", "latin1" }
vim.opt.fileformats = { "unix", "dos", "mac" }
