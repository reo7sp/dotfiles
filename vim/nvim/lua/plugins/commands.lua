return {

  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\><c-\>]],
        autochdir = true,
        shade_terminals = false,
      })
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,
  },

  {
    "tpope/vim-eunuch",
  },

  {
    "tpope/vim-dispatch",
  },

  {
    "stevearc/overseer.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
    },
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerRun",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerClearCache",
      "OverseerLoadBundle",
      "OverseerSaveBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
    },
    opts = {
      strategy = {
        "toggleterm",
        use_shell = true,
      }
    },
  },

  {
    "tpope/vim-fugitive",
  },

  {
    "rickhowe/diffchar.vim",
    init = function()
      vim.g.DiffCharDoMapping = 0
    end,
  },

  {
    "rickhowe/spotdiff.vim",
    init = function()
      vim.g.VDiffDoMapping = 0
    end,
  },

  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "esmuellert/codediff.nvim",
    },
    opts = {
      graph_style = "unicode",
      integrations = {
        telescope = true,
        codediff = true,
      },
    },
    keys = {
      {
        "<leader>gg",
        "<cmd>Neogit<cr>",
      },
    },
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    init = function()
      vim.g.lazygit_floating_window_use_plenary = 1
    end,
    keys = {
      {
        "<leader>gG",
        "<cmd>LazyGit<cr>",
      },
    },
  },

  {
    "esmuellert/codediff.nvim",
    config = function()
      require("codediff").setup({
        explorer = {
          view_mode = "tree",
          icons = {
            folder_closed = "",
            folder_open = "",
          },
        },
        keymaps = {
          view = {
            next_hunk = "]h",
            prev_hunk = "[h",
          }
        }
      })
      vim.keymap.set("n", "<leader>gd", "<cmd>CodeDiff<cr>")
      vim.keymap.set({ "n", "v" }, "<leader>gD", "<cmd>CodeDiff history<cr>")
    end,
  },

  {
    "Almo7aya/openingh.nvim",
    opts = {},
  },

}
