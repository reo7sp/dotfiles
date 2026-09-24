return {

  {
    "reo7sp/vim-unimpaired",
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "smartpde/telescope-recent-files",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "princejoogie/dir-telescope.nvim",
      "LukasPietzschmann/telescope-tabs",
      "jmacadie/telescope-hierarchy.nvim",
      "natecraddock/workspaces.nvim",
      "piersolenski/import.nvim",
      "gbprod/yanky.nvim",
      "stevearc/aerial.nvim",
      "folke/trouble.nvim",
      "romgrk/barbar.nvim",
    },
    config = function()
      local function file_path_display(opts, path)
        local path_opts = vim.tbl_extend("force", {}, opts, { path_display = {}, })
        local display = require("telescope.utils").transform_path(path_opts, path)
        return (opts.disable_devicons and "" or " ") .. display
      end

      require("telescope").setup({
        defaults = {
          mappings = {
            n = {
              ["q"] = require("telescope.actions").close,
              ["<C-Down>"] = require("telescope.actions").cycle_history_next,
              ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
              ["<C-t>"] = require("trouble.sources.telescope").open,
              ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
            },
            i = {
              ["<C-Down>"] = require("telescope.actions").cycle_history_next,
              ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
              ["<C-t>"] = require("trouble.sources.telescope").open,
              ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
            },
          },
          initial_mode = "insert",
          sorting_strategy = "ascending",
          dynamic_preview_title = true,
          set_env = {
            LESS = "",
            DELTA_PAGER = "less",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            path_display = file_path_display,
            mappings = {
              n = {
                ["<C-i>"] = function () require("telescope.builtin").find_files({ no_ignore = true }) end,
              },
              i = {
                ["<C-i>"] = function () require("telescope.builtin").find_files({ no_ignore = true }) end,
              },
            },
          },
          buffers = {
            show_all_buffers = false,
            sort_buffers = function (a, b)
              local index_of = require("barbar.utils.list").index_of
              local state = require("barbar.state")
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
            ignore_symbols = {
              "variable",
              "field",
            },
          },
        },
        extensions = {
          ["ui-select"] = vim.tbl_extend("force", require("telescope.themes").get_cursor({
            layout_config = {
              height = 15+4,
            },
          }), {}),
          recent_files = {
            stat_files = false,
            only_cwd = true,
            show_current_file = true,
            path_display = file_path_display,
            ignore_patterns = {
              "^/tmp/",
              "Scratch$",
              "Bqf[^/]*$",
              "quickfix[^/]*$",
              "^jumppack://",
              "^health://",
              "^trouble",
              "NvimTree_%d+$",
              "^oil",
              "^aerial",
              "undotree_%d+$",
              "Grug FAR[^/]*$",
              "guihua[^/]*$",
              "^gitsigns",
              "fugitiveblame$",
              "^flog",
              "CodeCompanion[^/]*$",
              "Plugins$",
              "COMMIT_",
              "%-todo$",
            },
          },
          live_grep_args = {
            mappings = {
              n = {
                ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                ["<C-f>"] = require("telescope-live-grep-args.actions").quote_prompt({
                  postfix = " -F ",
                }),
                ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({
                  postfix = " -u ",
                }),
                ["<C-y>"] = require("telescope-live-grep-args.actions").quote_prompt({
                  postfix = " -t ",
                }),
                ["<C-g>"] = require("telescope-live-grep-args.actions").quote_prompt({
                  postfix = " -g ",
                }),
              },
              i = {
                ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                ["<C-f>"] = require("telescope-live-grep-args.actions").quote_prompt({
                  postfix = " -F ",
                }),
                ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({
                  postfix = " -u ",
                }),
                ["<C-y>"] = require("telescope-live-grep-args.actions").quote_prompt({
                  postfix = " -t ",
                }),
                ["<C-g>"] = require("telescope-live-grep-args.actions").quote_prompt({
                  postfix = " -g ",
                }),
              },
            },
          },
          aerial = {
            show_columns = "symbols",
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("recent_files")
      require("telescope").load_extension("live_grep_args")
      require("telescope").load_extension("dir")
      require("telescope").load_extension("telescope-tabs")
      require("telescope-tabs").setup({
        close_tab_shortcut_i = "<M-d>",
        close_tab_shortcut_n = "<M-d>",
      })
      require("telescope").load_extension("yank_history")
      require("telescope").load_extension("aerial")
      require("telescope").load_extension("hierarchy")
      require("telescope").load_extension("workspaces")

      -- https://github.com/nvim-telescope/telescope.nvim/issues/605
      local actions = require("telescope.actions")
      local previewers = require("telescope.previewers")
      local builtin = require("telescope.builtin")
      local M = {}
      local git_status_previewer = previewers.new_termopen_previewer({
        get_command = function(entry)
          if entry.status == "??" or "A " then
              return { "git", "-c", "core.pager=delta", "-c", "delta.paging=always", "diff", "--no-ext-diff", entry.value }
          end
          return { "git", "-c", "core.pager=delta", "-c", "delta.paging=always", "diff", "--no-ext-diff", entry.value .. "^!" }
        end
      })
      local git_commits_previewer = previewers.new_termopen_previewer({
        get_command = function(entry)
          if entry.status == "??" or "A " then
              return { "git", "-c", "core.pager=delta", "-c", "delta.paging=always", "show", "--no-ext-diff", entry.value }
          end
          return { "git", "-c", "core.pager=delta", "-c", "delta.paging=always", "show", "--no-ext-diff", entry.value .. "^!" }
        end
      })
      local function run_git_picker(picker, opts)
          opts = opts or {}
          local cwd = opts.cwd or vim.fn.getcwd()
          if not vim.fs.find(".git", { path = cwd, upward = true })[1] then
            vim.notify("Not a Git repository: " .. cwd, vim.log.levels.ERROR, {
              title = "Telescope Git",
            })
            return
          end

          local ok, err = pcall(picker, opts)
          if not ok then
            local message = tostring(err):gsub("^.-:%d+:%s*", "")
            vim.notify(message, vim.log.levels.ERROR, {
              title = "Telescope Git",
            })
          end
      end
      M.git_status = function(opts)
          opts = opts or {}
          opts.previewer = git_status_previewer
          run_git_picker(builtin.git_status, opts)
      end
      M.git_bcommits = function(opts)
          opts = opts or {}
          opts.previewer = git_commits_previewer
          run_git_picker(builtin.git_bcommits, opts)
      end
      M.git_commits = function(opts)
          opts = opts or {}
          opts.previewer = git_commits_previewer
          run_git_picker(builtin.git_commits, opts)
      end
      M.git_branches = function(opts)
          run_git_picker(builtin.git_branches, opts)
      end
      vim.keymap.set("n", "<leader>ge", M.git_status, { desc = "Telescope git_status", })

      vim.keymap.set("n", "gF", function()
        require("telescope.builtin").find_files({
          default_text = vim.fn.expand("<cword>"),
        })
      end, {
        noremap = true,
        silent = true,
        desc = "Find files with word under cursor",
      })
      vim.keymap.set("v", "gF", function()
        vim.cmd("normal! \"vy")
        require("telescope.builtin").find_files({
          default_text = vim.fn.getreg("v"),
        })
      end, {
        noremap = true,
        silent = true,
        desc = "Find files with selected text",
      })
      vim.keymap.set("v", "<leader>f", function()
        vim.cmd("normal! \"vy")
        require("telescope.builtin").find_files({
          default_text = vim.fn.getreg("v"),
        })
      end, {
        noremap = true,
        silent = true,
        desc = "Find files with selected text",
      })

      require("import").setup({
        picker = "telescope",
      })
      vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Find LSP definitions", })
      vim.keymap.set("n", "gD", "<cmd>Telescope lsp_implementations<cr>", { desc = "Find LSP implementations", })
      vim.keymap.set("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Find LSP type definitions", })
      vim.keymap.set("n", "ge", "<cmd>Telescope lsp_references<cr>", { desc = "Find LSP references", })
      vim.keymap.set("n", "gE", "<cmd>Telescope hierarchy<cr>", { desc = "Find LSP hierarchy", })
      vim.keymap.set("n", "gs", function()
        require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()
      end, { desc = "Grep word under cursor", })
      vim.keymap.set("n", "<leader>e", function()
        require("telescope").extensions.recent_files.pick()
      end, { desc = "Find recent files", })
      vim.keymap.set("n", "<leader>E", function()
        require("telescope").extensions.recent_files.pick({ only_cwd = false })
      end, { desc = "Find all recent files", })
      vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<cr>", { desc = "Find files", })
      vim.keymap.set("n", "<leader>Ff", "<cmd>Telescope dir find_files<cr>", { desc = "Find files in directory", })
      vim.keymap.set("n", "<leader>s", "<cmd>Telescope live_grep_args<cr>", { desc = "Live grep", })
      vim.keymap.set("v", "<leader>s", function()
        require("telescope-live-grep-args.shortcuts").grep_visual_selection()
      end, { desc = "Grep selected text", })
      vim.keymap.set("v", "gs", function()
        require("telescope-live-grep-args.shortcuts").grep_visual_selection()
      end, { desc = "Grep selected text", })
      vim.keymap.set("n", "<leader>Fs", "<cmd>Telescope dir live_grep<cr>", { desc = "Live grep in directory", })
      vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "Find buffers", })
      vim.keymap.set("n", "<leader>B", "<cmd>Telescope telescope-tabs list_tabs<cr>", { desc = "Find tabs", })
      vim.keymap.set("n", "<leader>y", "<cmd>Telescope yank_history<cr>", { desc = "Find yank history", })
      vim.keymap.set("n", "<leader>k", "<cmd>Telescope aerial initial_mode=insert<cr>", { desc = "Find symbols", })
      vim.keymap.set("n", "<leader>K", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Find workspace symbols", })
      vim.keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Find buffer diagnostics", })
      vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics<CR>", { desc = "Find diagnostics", })
      vim.keymap.set("n", "<leader>Q", "<cmd>Telescope quickfixhistory<cr>", { desc = "Find quickfix history", })
      vim.keymap.set("n", "<leader>gb", M.git_branches, { desc = "Find git branches", })
      vim.keymap.set("n", "<leader>i", "<cmd>Import<cr>", { desc = "Import symbol", })
      vim.keymap.set("n", "<leader>m", "<cmd>Telescope marks<cr>", { desc = "Find marks", })
      vim.keymap.set("n", "<leader>'", "<cmd>Telescope marks<cr>", { desc = "Find marks", })
      vim.keymap.set("n", "<leader>`", "<cmd>Telescope marks<cr>", { desc = "Find marks", })
      vim.keymap.set("n", "<leader>\"", "<cmd>Telescope registers<cr>", { desc = "Find registers", })
      vim.keymap.set("n", "<leader>.", "<cmd>Telescope resume<cr>", { desc = "Resume Telescope", })
      vim.keymap.set("n", "<leader>/", function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end, { desc = "Fuzzy find in current buffer", })
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
  },

  {
    "smartpde/telescope-recent-files",
  },

  {
    "nvim-telescope/telescope-live-grep-args.nvim",
  },

  {
    "princejoogie/dir-telescope.nvim",
  },

  {
    "LukasPietzschmann/telescope-tabs",
  },

  {
    "jmacadie/telescope-hierarchy.nvim",
  },

  {
    "piersolenski/import.nvim",
  },

  {
    "junegunn/fzf",
    build = "./install --bin",
  },

  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local M = {}

      local oil_columns = require("oil.columns")
      local icon_column = oil_columns.get_column(nil, "icon")
      oil_columns.register("icon_gap", {
        render = function(entry, _, bufnr)
          local icon = icon_column.render(entry, { add_padding = false, }, bufnr)
          return { icon[1] .. " ", icon[2], }
        end,
        parse = icon_column.parse,
      })

      function M.launch_live_grep(opts)
        return M.launch_telescope("live_grep", opts)
      end

      function M.launch_find_files(opts)
        return M.launch_telescope("find_files", opts)
      end

      function M.launch_telescope(func_name, opts)
        local basedir = require("oil").get_current_dir()
        if basedir then
          basedir = basedir:gsub("oil://", "")
          opts = opts or {}
          opts.cwd = basedir
          opts.search_dirs = { basedir }
          require("telescope.builtin")[func_name](opts)
        end
      end

      require("oil").setup({
        columns = {
          "icon_gap",
        },
        view_options = {
          show_hidden = true,
        },
        watch_for_changes = true,
        git = {
          add = function(path)
            return true
          end,
          mv = function(src_path, dest_path)
            return true
          end,
          rm = function(path)
            return true
          end,
        },
        keymaps = {
          ["q"] = {
            "actions.close",
            mode = "n",
          },
          ["<C-x>"] = {
            "actions.select",
            opts = {
              horizontal = true,
            },
          },
          ["<C-v>"] = {
            "actions.select",
            opts = {
              vertical = true,
            },
          },
          ["<C-h>"] = false,
          ["<C-f>"] = {
            callback = function()
              M.launch_find_files()
            end,
            desc = "Launch Find Files",
          },
          ["<leader>f"] = {
            callback = function()
              M.launch_find_files()
            end,
            desc = "Launch Find Files",
          },
          ["<C-s>"] = {
            callback = function()
              M.launch_live_grep()
            end,
            desc = "Launch Live Grep",
          },
          ["<leader>s"] = {
            callback = function()
              M.launch_live_grep()
            end,
            desc = "Launch Live Grep",
          },
        },
      })

      vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory", })
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "s1n7ax/nvim-window-picker",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local api = require("nvim-tree.api")
      local openfile = require("nvim-tree.actions.node.open-file")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local M = {}

      local view_selection = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local filename = selection.filename
          if (filename == nil) then
            filename = selection[1]
          end
          openfile.fn("preview", filename)
        end)
        return true
      end

      function M.launch_live_grep(opts)
        return M.launch_telescope("live_grep", opts)
      end

      function M.launch_find_files(opts)
        return M.launch_telescope("find_files", opts)
      end

      function M.launch_telescope(func_name, opts)
        local node = api.tree.get_node_under_cursor()
        local is_folder = node.fs_stat and node.fs_stat.type == "directory" or false
        local basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
        if (node.name == ".." and TreeExplorer ~= nil) then
          basedir = TreeExplorer.cwd
        end
        opts = opts or {}
        opts.cwd = basedir
        opts.search_dirs = { basedir }
        opts.attach_mappings = view_selection
        require("telescope.builtin")[func_name](opts)
      end

      function M.cd_to_tree_root()
        local cwd = require("nvim-tree.core").get_cwd()
        if (cwd ~= nil) then
          vim.cmd("cd " .. vim.fn.fnameescape(cwd))
        end
      end

      function M.open_tree_cwd()
        local node = api.tree.get_node_under_cursor()
        local filename = node and node.name ~= ".." and node.absolute_path or nil
        api.tree.change_root(vim.fn.getcwd(-1, -1))
        api.tree.reload()
        api.tree.open()
        if (filename ~= nil) then
          api.tree.find_file({
            buf = filename,
            focus = true,
          })
        end
      end

      function M.change_root_down()
        local node = api.tree.get_node_under_cursor()
        local is_file = node and node.fs_stat and node.fs_stat.type ~= "directory"
        local filename = is_file and node.absolute_path or nil
        api.tree.change_root_to_node()
        if (filename ~= nil) then
          api.tree.find_file({
            buf = filename,
            focus = true,
          })
        end
        vim.cmd("normal! zb")
      end

      require("nvim-tree").setup({
        renderer = {
          root_folder_label = false,
          indent_markers = {
            enable = true,
          },
          icons = {
            padding = {
              icon = "  ",
            },
            show = {
              folder_arrow = false,
            },
          },
        },
        view = {
          signcolumn = "no",
          width = 35,
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
          custom = { "^.git$" },
        },
        actions = {
          change_dir = {
            enable = false,
          },
          open_file = {
            quit_on_open = false,
            window_picker = {
              enable = true,
              picker = function ()
                return require("window-picker").pick_window({
                  filter_rules = {
                    bo = {
                      filetype = {
                        "NvimTree",
                        "aerial",
                        "trouble",
                      },
                      buftype = {
                        "terminal",
                      },
                    },
                  },
                })
              end,
            },
          },
        },
        on_attach = function (bufnr)
          local api = require("nvim-tree.api")

          local function opts(desc)
            return {
              desc = "nvim-tree: " .. desc,
              buffer = bufnr,
              silent = true,
              nowait = true,
            }
          end

          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.del("n", "<C-]>", {
            buffer = bufnr,
          })
          vim.keymap.set("n", "<c-f>", M.launch_find_files, opts("Launch Find Files"))
          vim.keymap.set("n", "<c-s>", M.launch_live_grep, opts("Launch Live Grep"))
          vim.keymap.set("n", "`", M.cd_to_tree_root, opts("CD To Tree Root"))
          vim.keymap.set("n", "_", M.open_tree_cwd, opts("Open CWD"))
          vim.keymap.set("n", "go", M.change_root_down, opts("Down To File"))
          vim.keymap.set("n", "gs", api.node.run.system, opts("Run System"))
        end,
      })
    end,
    cmd = {
      "NvimTreeToggle",
      "NvimTreeOpen",
      "NvimTreeClose",
      "NvimTreeFocus",
      "NvimTreeFindFile",
    },
    keys = {
      {
        "<leader>t",
        function()
          require("nvim-tree.api").tree.toggle({
            find_file = true,
            focus = false,
          })
        end,
        desc = "Toggle file tree",
      },
      {
        "_",
        function()
          if (vim.bo.filetype == "oil" or vim.bo.filetype == "NvimTree") then
            return
          end
          require("nvim-tree.api").tree.open({
            find_file = true,
            focus = true,
            update_root = true,
          })
        end,
        desc = "Focus current file in tree",
      },
    },
  },

  {
    "stevearc/aerial.nvim",
    version = "*",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "onsails/lspkind.nvim",
    },
    config = function()
      local sidebar_width = 35

      require("aerial").setup({
        layout = {
          placement = "edge",
          default_direction = "left",
          min_width = sidebar_width,
          width = sidebar_width,
          win_opts = {
            winhighlight = "NormalNC:Normal",
          },
        },
        attach_mode = "global",
        close_on_select = false,
        autojump = true,
        show_guides = true,
        icons = vim.tbl_map(function(icon)
          return icon .. " "
        end, vim.tbl_extend("force", require("lspkind").presets.default, {
          Field = "",
          Method = "󰊕",
          Property = "",
        })),
        use_icon_provider = false,
        disable_max_lines = 99999,
        disable_max_size = 1000 * 1024,
      })

      vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
          for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local filetype = vim.bo[vim.api.nvim_win_get_buf(winid)].filetype
            if filetype == "aerial" or filetype == "NvimTree" then
              vim.api.nvim_win_set_width(winid, sidebar_width)
            end
          end
        end,
      })

      vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<cr>", { desc = "Toggle symbol outline", })
    end,
  },

  {
    "nanotee/zoxide.vim",
    init = function()
      vim.g.zoxide_use_select = true
    end,
  },

  {
    "rgroli/other.nvim",
    main = "other-nvim",
    opts = {
      mappings = {
        -- h -> cpp
        {
          pattern = "(.*)%.h$",
          target  = "%1.cpp",
          context = "c",
        },
        -- cpp -> h
        {
          pattern = "(.*)%.cpp$",
          target  = "%1.h",
          context = "c",
        },
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
        -- include/<namespace>/name.h -> src/name.cpp
        {
          pattern = "(.+)/include/.*/([^/]+)%.h$",
          target  = "%1/src/%2.cpp",
          context = "c",
        },
        -- cpp -> h
        {
          pattern = "(.+)/src/(.+)%.cpp$",
          target  = {
            "%1/include/%2.h",
            "%1/include/**/%2.h",
          },
          context = "c",
        },
        -- hpp -> cpp
        {
          pattern = "(.+)/include/(.+)%.hpp$",
          target  = "%1/src/%2.cpp",
          context = "c",
        },
        -- cpp -> hpp
        {
          pattern = "(.+)/src/(.+)%.cpp$",
          target  = "%1/include/%2.hpp",
          context = "c",
        },
        -- proto -> generated C++ source
        {
          pattern = "(.*)%.proto$",
          target = "%1_pb2.cpp",
          context = "c",
        },
        -- generated C++ source -> proto
        {
          pattern = "(.*)_pb2%.cpp$",
          target = "%1.proto",
          context = "c",
        },
        -- proto -> generated Go source
        {
          pattern = "(.*)%.proto$",
          target = "%1_pb2.go",
          context = "golang",
        },
        -- generated Go source -> proto
        {
          pattern = "(.*)_pb2%.go$",
          target = "%1.proto",
          context = "golang",
        },
        -- proto -> generated Python stub
        {
          pattern = "(.*)%.proto$",
          target = "%1_pb2.pyi",
          context = "python",
        },
        -- generated Python stub -> proto
        {
          pattern = "(.*)_pb2%.pyi$",
          target = "%1.proto",
          context = "python",
        },
        -- proto -> generated Python module
        {
          pattern = "(.*)%.proto$",
          target = "%1_pb2.py",
          context = "python",
        },
        -- generated Python module -> proto
        {
          pattern = "(.*)_pb2%.py$",
          target = "%1.proto",
          context = "python",
        },
        "c",
        "golang",
        "python",
      },
    },
    cmd = {
      "Other",
      "OtherTabNew",
      "OtherSplit",
      "OtherVSplit",
      "OtherClear",
    },
    keys = {
      {
        "<leader>a",
        "<cmd>Other<cr>",
        desc = "Open alternate file",
      },
    },
  },

  {
    "MagicDuck/grug-far.nvim",
    opts = {
      instanceName = "grug-far",
      normalModeSearch = true,
      startInInsertMode = false,
      transient = true,
      history = {
        maxHistoryLines = 1000,
      },
    },
    keys = {
      {
        "<leader>S",
        function()
          require("grug-far").kill_instance()
          require("grug-far").open()
        end,
        desc = "Search and replace",
      },
      {
        "<leader>S",
        function()
          require("grug-far").kill_instance()
          require("grug-far").with_visual_selection()
        end,
        mode = "v",
        desc = "Search and replace selection",
      },
    },
  },

}
