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

      local group = vim.api.nvim_create_augroup("codediff-keymaps", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "CodeDiffOpen",
        callback = function(args)
          local tabpage = args.data and args.data.tabpage
          if not tabpage then
            return
          end

          require("codediff.ui.lifecycle").set_tab_keymap(tabpage, "n", "]c", "<Nop>", { desc = "Disabled in CodeDiff" })
          require("codediff.ui.lifecycle").set_tab_keymap(tabpage, "n", "[c", "<Nop>", { desc = "Disabled in CodeDiff" })
        end,
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
    "dlyongemallo/diffview-plus.nvim",
    name = "diffview.nvim",
    version = "*",
    init = function()
      vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "ShellCmdPost", "TermClose" }, {
        group = vim.api.nvim_create_augroup("diffview-auto-refresh", { clear = true }),
        callback = function(args)
          if not package.loaded["diffview"] then
            return
          end

          local current_view = require("diffview.lib").get_current_view()
          for _, view in ipairs(require("diffview.lib").views) do
            if args.event ~= "BufWritePost" or view ~= current_view then
              view.emitter:emit("refresh_files")
            end
          end
        end,
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      return {
        use_icons = false,
        enhanced_diff_hl = true,
        keymaps = {
          view = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "]h", "]c", { desc = "Next hunk" } },
            { "n", "[h", "[c", { desc = "Previous hunk" } },
            { "n", "]c", "<Nop>" },
            { "n", "[c", "<Nop>" },
            { "n", "]f", require("diffview.actions").select_next_entry, { desc = "Next file" } },
            { "n", "[f", require("diffview.actions").select_prev_entry, { desc = "Previous file" } },
            { "n", "t", require("diffview.actions").cycle_layout, { desc = "Toggle layout" } },
          },
          file_panel = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
            { "n", "]f", require("diffview.actions").select_next_entry, { desc = "Next file" } },
            { "n", "[f", require("diffview.actions").select_prev_entry, { desc = "Previous file" } },
          },
          file_history_panel = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          },
        },
        hooks = {
          view_opened = function(view)
            local old_views = {}
            for _, old_view in ipairs(require("diffview.lib").views) do
              if old_view ~= view then
                old_views[#old_views + 1] = old_view
              end
            end
            for _, old_view in ipairs(old_views) do
              old_view:close()
              require("diffview.lib").dispose_view(old_view)
            end
          end,
          diff_buf_win_enter = function(bufnr)
            vim.b[bufnr].ignore_early_retirement = true
            vim.opt_local.cursorlineopt = "number"
            vim.opt_local.fillchars:append({ diff = " " })
          end,
        },
      }
    end,
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
      "DiffviewDiffFiles",
      "DiffviewMergeFiles",
      "DiffviewDiffDirs",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
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
