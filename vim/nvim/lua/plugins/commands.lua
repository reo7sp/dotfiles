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
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { buffer = 0, desc = "Focus left window", })
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { buffer = 0, desc = "Focus lower window", })
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { buffer = 0, desc = "Focus upper window", })
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { buffer = 0, desc = "Focus right window", })
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { buffer = 0, desc = "Terminal window command", })
      end
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
      vim.api.nvim_create_user_command("T", function(opts)
        require("toggleterm").exec(opts.args)
      end, {
        nargs = "+",
        complete = "shellcmd",
      })
    end,
    cmd = {
      "ToggleTerm",
      "ToggleTermToggleAll",
      "TermExec",
      "T",
    },
    keys = {
      {
        [[<c-\><c-\>]],
        "<cmd>ToggleTerm<cr>",
        desc = "Toggle terminal",
      },
    },
  },

  {
    "tpope/vim-eunuch",
    cmd = {
      "Mkdir",
      "Unlink",
      "Remove",
      "Delete",
      "Copy",
      "Move",
      "Duplicate",
      "Rename",
      "Chmod",
      "Cfind",
      "Clocate",
      "Lfind",
      "Llocate",
      "SudoEdit",
      "SudoWrite",
      "Wall",
      "W",
    },
  },

  {
    "tpope/vim-dispatch",
    cmd = {
      "Dispatch",
      "FocusDispatch",
      "Make",
      "Spawn",
      "Start",
      "Copen",
      "AbortDispatch",
    },
  },

  {
    "stevearc/overseer.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
    },
    opts = {
      strategy = {
        "toggleterm",
        use_shell = true,
      }
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
    cmd = {
      "Diffthis",
      "Diffoff",
      "Diffupdate",
      "VDiffthis",
      "VDiffoff",
      "VDiffupdate",
    },
  },

  {
    "NeogitOrg/neogit",
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
    cmd = "Neogit",
    keys = {
      {
        "<leader>gg",
        "<cmd>Neogit<cr>",
        desc = "Open Neogit",
      },
    },
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    init = function()
      vim.g.lazygit_floating_window_use_plenary = 1
    end,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      {
        "<leader>gG",
        "<cmd>LazyGit<cr>",
        desc = "Open LazyGit",
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
    end,
    cmd = "CodeDiff",
    keys = {
      {
        "<leader>gd",
        "<cmd>CodeDiff<cr>",
        desc = "Open diff",
      },
      {
        "<leader>gD",
        "<cmd>CodeDiff history<cr>",
        mode = { "n", "v" },
        desc = "Open diff for current file",
      },
    },
  },

  {
    "Almo7aya/openingh.nvim",
    opts = {},
    cmd = {
      "OpenInGHRepo",
      "OpenInGHFile",
      "OpenInGHFileLines",
    },
  },

  {
    "folke/sidekick.nvim",
    config = function()
      require("sidekick").setup({
        nes = {
          enabled = false,
        },
        cli = {
          picker = "telescope",
        },
      })
      vim.api.nvim_set_hl(0, "SidekickChat", { link = "Normal" })
    end,
    keys = {
      {
        "<leader>c",
        function()
          require("sidekick.cli").send({ msg = "{file}: " })
        end,
        desc = "Send file to agent",
      },
      {
        "<leader>c",
        function()
          require("sidekick.cli").send({ msg = "{file}: ```{selection}``` " })
        end,
        mode = "v",
        desc = "Send selection to agent",
      },
    },
  },

  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true

      local opencode_commands = {
        "agent.cycle",
        "prompt.clear",
        "prompt.submit",
        "session.compact",
        "session.first",
        "session.half.page.up",
        "session.half.page.down",
        "session.interrupt",
        "session.last",
        "session.new",
        "session.page.up",
        "session.page.down",
        "session.select",
        "session.share",
        "session.redo",
        "session.undo",
      }

      local function complete_opencode_command(arg_lead)
        return vim.tbl_filter(function(command)
          return vim.startswith(command, arg_lead)
        end, opencode_commands)
      end

      vim.api.nvim_create_user_command("OpenCode", function()
        require("opencode").select()
      end, {})

      vim.api.nvim_create_user_command("OpenCodeAsk", function(opts)
        local default = opts.args ~= "" and opts.args or "@this: "
        require("opencode").ask(default)
      end, {
        nargs = "*",
        range = true,
      })

      vim.api.nvim_create_user_command("OpenCodePrompt", function(opts)
        require("opencode").prompt(opts.args)
      end, {
        nargs = "+",
        range = true,
      })

      vim.api.nvim_create_user_command("OpenCodeCommand", function(opts)
        require("opencode").command(opts.args)
      end, {
        nargs = 1,
        complete = complete_opencode_command,
      })
    end,
    cmd = {
      "OpenCode",
      "OpenCodeAsk",
      "OpenCodePrompt",
      "OpenCodeCommand",
    },
  },

  {
    "coder/claudecode.nvim",
    config = true,
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeSendText",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
  },

  {
    "amitds1997/remote-nvim.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = {
      "RemoteStart",
      "RemoteStop",
      "RemoteInfo",
      "RemoteCleanup",
      "RemoteConfigDel",
      "RemoteLog",
    },
    opts = {},
  },

}
