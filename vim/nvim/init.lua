vim.loader.enable()

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
vim.opt.termguicolors = true

local data_path = vim.fn.stdpath("data")
local state_path = vim.fn.stdpath("state")
local lazy_path = data_path .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
vim.fn.mkdir(state_path .. "/backup", "p")
vim.fn.mkdir(state_path .. "/swap", "p")
vim.fn.mkdir(state_path .. "/undo", "p")
vim.fn.mkdir(state_path .. "/view", "p")
vim.o.backupdir = state_path .. "/backup//"
vim.o.directory = state_path .. "/swap//"
vim.o.undodir = state_path .. "/undo//"
vim.o.viewdir = state_path .. "/view"

if not uv.fs_stat(lazy_path) then
  local lazy_repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazy_repo,
    lazy_path,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazy_path)

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<space>", "<nop>")

require("lazy").setup({
  spec = require("plugins"),
  root = data_path .. "/lazy",
  install = { colorscheme = { "catppuccin-latte" } },
})

require("commands")
require("settings")
