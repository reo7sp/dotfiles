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
    "esmuellert/codediff.nvim",
    config = function()
      require("codediff").setup({
        explorer = {
          view_mode = "tree",
        },
        keymaps = {
          view = {
            next_hunk = "]h",
            prev_hunk = "[h",
            stage_hunk = false,
            unstage_hunk = false,
            discard_hunk = false,
            show_help = false,
          }
        }
      })

      local group = vim.api.nvim_create_augroup("codediff-keymaps", { clear = true })
      local lifecycle = require("codediff.ui.lifecycle")
      local hunk = require("codediff.ui.view.actions.hunk")

      local function context(tabpage)
        local session = lifecycle.get_session(tabpage)
        local original_bufnr, modified_bufnr = lifecycle.get_buffers(tabpage)
        return session, {
          tabpage = tabpage,
          original_bufnr = original_bufnr,
          modified_bufnr = modified_bufnr,
          is_explorer_mode = lifecycle.get_panel_name(tabpage) == "explorer",
          is_history_mode = lifecycle.get_panel_name(tabpage) == "history",
          is_inline = session and session.layout == "inline" or false,
          is_conflict = session and session.merge == true or false,
        }
      end

      local function set_hunk_keymaps(tabpage, bufnr)
        lifecycle.set_buf_keymap(tabpage, bufnr, "n", "gh", function()
          local session, ctx = context(tabpage)
          if session and session.modified_revision == ":0" then
            hunk.unstage_hunk(ctx)
          else
            hunk.stage_hunk(ctx)
          end
        end, { desc = "Stage/unstage git hunk" })
        lifecycle.set_buf_keymap(tabpage, bufnr, "n", "gH", function()
          local _, ctx = context(tabpage)
          hunk.discard_hunk(ctx)
        end, { desc = "Discard git hunk" })
      end

      local function set_keymaps_when_ready(tabpage, attempts)
        local session = lifecycle.get_session(tabpage)
        if not session then
          if attempts > 0 then
            vim.defer_fn(function()
              set_keymaps_when_ready(tabpage, attempts - 1)
            end, 50)
          end
          return
        end

        local original_bufnr, modified_bufnr = lifecycle.get_buffers(tabpage)
        for _, bufnr in ipairs({ original_bufnr, modified_bufnr }) do
          if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
            set_hunk_keymaps(tabpage, bufnr)
          end
        end
        lifecycle.set_tab_keymap(tabpage, "n", "]c", "<Nop>", { desc = "<Nop>" })
        lifecycle.set_tab_keymap(tabpage, "n", "[c", "<Nop>", { desc = "<Nop>" })
      end

      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = { "CodeDiffOpen", "CodeDiffFileSelect", "CodeDiffVirtualFileLoaded" },
        callback = function(args)
          local tabpage = args.data and args.data.tabpage
          if tabpage then
            set_keymaps_when_ready(tabpage, 40)
          else
            vim.defer_fn(function()
              for _, candidate in ipairs(vim.api.nvim_list_tabpages()) do
                if lifecycle.get_session(candidate) then
                  set_keymaps_when_ready(candidate, 1)
                end
              end
            end, 100)
          end
        end,
      })
      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
        group = group,
        callback = function()
          vim.schedule(function()
            local win = vim.api.nvim_get_current_win()
            local tabpage = vim.api.nvim_win_get_tabpage(win)
            local bufnr = vim.api.nvim_win_get_buf(win)
            local original_bufnr, modified_bufnr = lifecycle.get_buffers(tabpage)
            if bufnr == original_bufnr or bufnr == modified_bufnr then
              set_hunk_keymaps(tabpage, bufnr)
            end
          end)
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "CodeDiffClose",
        callback = function(args)
          local tabpage = args.data and args.data.tabpage
          local session = tabpage and require("codediff.ui.lifecycle").get_session(tabpage)
          if not session then
            return
          end

          local buffers = {
            session.original_bufnr,
            session.modified_bufnr,
            session.result_bufnr,
            session.panel and session.panel.view and session.panel.view.bufnr,
          }
          vim.schedule(function()
            for _, bufnr in ipairs(buffers) do
              if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
                local name = vim.api.nvim_buf_get_name(bufnr)
                local is_real_file = vim.bo[bufnr].buftype == ""
                    and name ~= ""
                    and vim.fn.filereadable(name) == 1
                if not is_real_file then
                  pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
                end
              end
            end
          end)
        end,
      })
    end,
    cmd = "CodeDiff",
    keys = {
      {
        "<leader>gd",
        function()
          local lifecycle = require("codediff.ui.lifecycle")
          for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
            if lifecycle.get_panel_name(tabpage) == "explorer" then
              vim.api.nvim_set_current_tabpage(tabpage)
              return
            end
          end
          vim.cmd("CodeDiff")
        end,
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

  (function()
    local diffview_fold_state = {}

    local function save_diffview_folds()
      if not package.loaded["diffview"] then
        return
      end

      local view = require("diffview.lib").get_current_view()
      if not (view and view.cur_layout) then
        return
      end

      local saved = {}
      for _, win in ipairs(view.cur_layout.windows) do
        if win.file and win.file.bufnr and vim.api.nvim_win_is_valid(win.id)
            and vim.wo[win.id].foldmethod == "diff" then
          saved[win.id] = vim.api.nvim_win_call(win.id, function()
            local opened = {}
            local previous_level = 0
            for line = 1, vim.api.nvim_buf_line_count(win.file.bufnr) do
              local level = vim.fn.foldlevel(line)
              if level > previous_level and vim.fn.foldclosed(line) == -1 then
                opened[#opened + 1] = line
              end
              previous_level = level
            end
            return {
              bufnr = win.file.bufnr,
              foldlevel = vim.wo.foldlevel,
              opened = opened,
            }
          end)
        end
      end
      diffview_fold_state[view.tabpage] = saved
    end

    local function restore_diffview_folds(view, layout)
      local saved = diffview_fold_state[view.tabpage]
      if not saved or view.cur_layout ~= layout then
        return
      end

      for _, win in ipairs(layout.windows) do
        local state = saved[win.id]
        if state and win.file and state.bufnr == win.file.bufnr and vim.api.nvim_win_is_valid(win.id) then
          vim.wo[win.id].foldlevel = state.foldlevel
        end
      end

      for index = #layout.windows, 1, -1 do
        local win = layout.windows[index]
        local state = saved[win.id]
        if state and win.file and state.bufnr == win.file.bufnr and vim.api.nvim_win_is_valid(win.id) then
          vim.api.nvim_win_call(win.id, function()
            for _, line in ipairs(state.opened) do
              if line <= vim.api.nvim_buf_line_count(state.bufnr) and vim.fn.foldlevel(line) > 0 then
                pcall(vim.cmd, line .. "foldopen")
              end
            end
          end)
        end
      end
    end

    return {
      "dlyongemallo/diffview-plus.nvim",
      name = "diffview.nvim",
      version = "*",
      init = function()
        vim.api.nvim_create_autocmd("TabLeave", {
          group = vim.api.nvim_create_augroup("diffview-save-folds", { clear = true }),
          callback = save_diffview_folds,
        })
        vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "ShellCmdPost", "TermClose" }, {
          group = vim.api.nvim_create_augroup("diffview-auto-refresh", { clear = true }),
          callback = function(args)
            if not package.loaded["diffview"] then
              return
            end

            save_diffview_folds()
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
        local function copy_hunk(target_type, missing_message)
          local view = require("diffview.lib").get_current_view()
          local layout = view and view.cur_layout
          if not layout then
            return
          end

          local target
          local source
          for _, win in ipairs(layout.windows) do
            if win.file and win.file.rev then
              if win.file.rev.type == target_type then
                target = win
              else
                source = win
              end
            end
          end

          if target and not source and layout.name == "diff1_inline" then
            require("diffview.actions").diffget_inline()
            vim.api.nvim_win_call(target.id, function()
              vim.cmd.write()
            end)
            return
          end

          if not (target and source and target.file.bufnr and source.file.bufnr) then
            vim.notify(missing_message, vim.log.levels.WARN)
            return
          end

          local current_buf = vim.api.nvim_get_current_buf()
          if current_buf == target.file.bufnr then
            vim.cmd("diffget " .. source.file.bufnr)
          elseif current_buf == source.file.bufnr then
            vim.cmd("diffput " .. target.file.bufnr)
          else
            return
          end

          vim.api.nvim_win_call(target.id, function()
            vim.cmd.write()
          end)
        end

        local RevType = require("diffview.vcs.rev").RevType
        local function gitsigns_hunk(action)
          local view = require("diffview.lib").get_current_view()
          local layout = view and view.cur_layout
          if not layout then
            return false
          end

          for _, win in ipairs(layout.windows) do
            if win.file and win.file.rev and win.file.rev.type == RevType.LOCAL then
              local line = vim.api.nvim_win_get_cursor(0)[1]
              vim.api.nvim_win_call(win.id, function()
                local line_count = vim.api.nvim_buf_line_count(win.file.bufnr)
                vim.api.nvim_win_set_cursor(win.id, { math.min(line, line_count), 0 })
                require("gitsigns")[action]()
              end)
              return true
            end
          end

          return false
        end

        local function reopen_as_staged_hunk()
          local view = require("diffview.lib").get_current_view()
          local current = view and view.cur_entry
          if not (current and current.path and view.files) then
            return false
          end

          for _, entry in ipairs(view.files.working) do
            if entry.path == current.path then
              return false
            end
          end

          local staged
          for _, entry in ipairs(view.files.staged) do
            if entry.path == current.path then
              staged = entry
              break
            end
          end
          if not staged then
            return false
          end

          local line = vim.api.nvim_win_get_cursor(0)[1]
          view:set_file(staged, true):finally(function()
            vim.schedule(function()
              local main = view.cur_layout and view.cur_layout:get_main_win()
              if main and main:is_valid() then
                local line_count = vim.api.nvim_buf_line_count(main.file.bufnr)
                vim.api.nvim_win_set_cursor(main.id, { math.min(line, line_count), 0 })
                copy_hunk(RevType.STAGE, "No index hunk to unstage")
              end
            end)
          end)
          return true
        end

        return {
          enhanced_diff_hl = true,
          show_help_hints = false,
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
              { "n", "gh", function()
                if not reopen_as_staged_hunk() and not gitsigns_hunk("stage_hunk") then
                  copy_hunk(RevType.STAGE, "No index hunk to unstage")
                end
              end, { desc = "Stage/unstage git hunk" } },
              { "n", "gH", function()
                if not gitsigns_hunk("reset_hunk") then
                  vim.notify("No unstaged hunk to discard", vim.log.levels.WARN)
                end
              end, { desc = "Discard git hunk" } },
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
            view_closed = function(view)
              diffview_fold_state[view.tabpage] = nil
            end,
            view_opened = function(view)
              local lib = require("diffview.lib")
              local existing_view
              for _, candidate in ipairs(lib.views) do
                if candidate ~= view and candidate.class == view.class then
                  existing_view = candidate
                  break
                end
              end

              if existing_view and vim.api.nvim_tabpage_is_valid(existing_view.tabpage) then
                view:close()
                lib.dispose_view(view)
                vim.api.nvim_set_current_tabpage(existing_view.tabpage)
                existing_view.emitter:emit("refresh_files")
              end
            end,
            diff_buf_win_enter = function(bufnr, winid)
              vim.b[bufnr].ignore_early_retirement = true
              vim.opt_local.cursorlineopt = "number"
              vim.opt_local.fillchars:append({ diff = " " })
              local view = require("diffview.lib").get_current_view()
              local layout = view and view.cur_layout
              if layout and diffview_fold_state[view.tabpage] and not layout._restore_folds_pending then
                layout._restore_folds_pending = true
                view.emitter:once("file_open_post", function()
                  layout._restore_folds_pending = false
                  vim.schedule(function()
                    restore_diffview_folds(view, layout)
                  end)
                end)
              end
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
    }
  end)(),

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

}
