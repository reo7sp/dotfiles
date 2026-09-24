return {

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        integrations = {
          aerial = true,
          barbar = true,
          blink_cmp = true,
          neogit = true,
          fidget = true,
          gitsigns = true,
          grug_far = true,
          mason = true,
          nvim_surround = true,
          ufo = true,
          window_picker = true,
          overseer = true,
          flash = true,
          render_markdown = true,
          telescope = {
            enabled = true,
          },
          lsp_trouble = true,
          illuminate = {
            enabled = true,
            lsp = false,
          },
          lualine = {
            latte = function(colors)
              return {
                normal = {
                  c = {
                    bg = colors.surface1,
                  },
                },
                inactive = {
                  a = {
                    bg = colors.surface1,
                    fg = colors.text,
                  },
                  b = {
                    bg = colors.surface1,
                    fg = colors.text,
                  },
                  c = {
                    bg = colors.surface1,
                    fg = colors.text,
                  },
                },
              }
            end,
          },
          which_key = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = {
                "undercurl",
              },
              hints = {
                "undercurl",
              },
              warnings = {
                "undercurl",
              },
              information = {
                "undercurl",
              },
            },
          },
        },
      })
      vim.cmd([[colorscheme catppuccin-latte]])
    end,
    lazy = false,
  },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = function()
            if vim.g.colors_name and vim.g.colors_name:match("^catppuccin") then
              return "catppuccin-nvim"
            end
            return "auto"
          end,
          icons_enabled = false,
          component_separators = {
            left = "",
            right = "",
          },
          section_separators = {
            left = "",
            right = "",
          },
        },
        extensions = {
          "aerial",
          "fugitive",
          "lazy",
          "mason",
          {
            sections = {
              lualine_a = {
                function()
                  local root = require("nvim-tree.core").get_cwd()
                  return root and vim.fn.fnamemodify(root, ":~") or ""
                end,
              },
            },
            filetypes = {
              "NvimTree",
            },
          },
          "oil",
          "overseer",
          "quickfix",
          "toggleterm",
          "trouble",
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return str:sub(1, 1)
              end,
              padding = {
                left = 1,
                right = 1,
              },
            },
          },
          lualine_b = {
          },
          lualine_c = {
            {
              "filename",
              path = 3,
              file_status = false,
              padding = {
                left = 1,
                right = 1,
              },
            },
            {
              "aerial",
              depth = 3,
              sep = " ",
              padding = {
                left = 0,
                right = 1,
              },
            },
          },
          lualine_x = {
            {
              "diagnostics",
              padding = {
                left = 1,
                right = 1,
              },
            },
            {
              function()
                local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
                if vim.api.nvim_buf_get_option(0, "expandtab") then
                  return "S:sw=" .. shiftwidth
                else
                  return "T:ts=" .. vim.api.nvim_buf_get_option(0, "tabstop")
                end
              end,
              padding = {
                left = 0,
                right = 1,
              },
            },
            {
              require("minuet.lualine"),
              padding = {
                left = 0,
                right = 1,
              },
            },
          },
          lualine_y = {
          },
          lualine_z = {
            {
              "location",
              padding = {
                left = 1,
                right = 1,
              },
            },
            {
              "searchcount",
              padding = {
                left = 0,
                right = 1,
              },
            },
            {
              "selectioncount",
              padding = {
                left = 0,
                right = 1,
              },
            },
          },
        },
        inactive_sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return str:sub(1, 1)
              end,
              padding = {
                left = 1,
                right = 1,
              },
            },
          },
          lualine_b = {
          },
          lualine_c = {
            {
              "filename",
              path = 3,
              file_status = false,
              padding = {
                left = 1,
                right = 1,
              },
            },
          },
          lualine_x = {
            {
              "location",
              padding = {
                left = 1,
                right = 1,
              },
            }
          },
          lualine_y = {
          },
          lualine_z = {
          },
        },
      })

      vim.o.fillchars = "vert:┃"
      vim.cmd([=[
        set noruler
      ]=])
    end,
    lazy = false,
  },

  {
    "romgrk/barbar.nvim",
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    config = function()
      vim.g.barbar_auto_setup = false
      require("barbar").setup({
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
            right = " ",
          },
          inactive = {
            separator = {
              right = " ",
            },
          },
          modified = {
            button = "",
          },
          pinned = {
            button = " ",
            filename = true,
          },
          separator_at_end = false,
        },
        minimum_padding = 0,
        maximum_padding = 0,
        sidebar_filetypes = {},
        no_name_title = "[No Name]",
      })
      vim.api.nvim_create_user_command("BufferCloseAllButVisibleOrPinned", function()
        local bdelete = require("barbar.bbye").bdelete
        local state = require("barbar.state")

        for _, bufnr in ipairs(state.buffers) do
          if not state.is_pinned(bufnr) and vim.fn.bufwinnr(bufnr) == -1 then
            bdelete(false, bufnr)
          end
        end
        require("barbar.ui.render").update()
      end, { desc = "Close every buffer except visible or pinned buffers" })
      vim.cmd([=[
        cnoreabbrev bq BufferClose
        cnoreabbrev bd BufferClose
        cnoreabbrev bo BufferCloseAllButCurrentOrPinned
        cnoreabbrev bon BufferCloseAllButVisibleOrPinned
        cnoreabbrev bonly BufferCloseAllButCurrentOrPinned
        cnoreabbrev bql BufferCloseBuffersLeft
        cnoreabbrev bdl BufferCloseBuffersLeft
        cnoreabbrev bqr BufferCloseBuffersRight
        cnoreabbrev bdr BufferCloseBuffersRight

        cnoreabbrev bpin BufferPin
        cnoreabbrev bpi BufferPin

        cnoreabbrev bss BufferOrderByName
        cnoreabbrev bsn BufferOrderByName
        cnoreabbrev bsd BufferOrderByDirectory
        cnoreabbrev bsl BufferOrderByLanguage
        cnoreabbrev bsw BufferOrderByWindowNumber
      ]=])
      vim.keymap.set("n", "[b", "<cmd>BufferPrevious<CR>", { desc = "Previous buffer", })
      vim.keymap.set("n", "]b", "<cmd>BufferNext<CR>", { desc = "Next buffer", })
      for i = 1, 8 do
        vim.keymap.set("n", "<C-" .. i .. ">", "<cmd>BufferGoto " .. i .. "<CR>", { desc = "Go to buffer " .. i, })
      end
      vim.keymap.set("n", "<C-9>", "<cmd>BufferLast<CR>", { desc = "Go to last buffer", })
      vim.keymap.set("n", "<c-q>", "<cmd>BufferClose<cr>", { desc = "Close buffer", })
      vim.keymap.set("n", "<c-w>Q", "<cmd>BufferClose<cr>", { desc = "Close buffer", })
      vim.keymap.set("n", "<c-w>O", "<cmd>BufferCloseAllButCurrentOrPinned<cr>", { desc = "Close other buffers", })
      vim.keymap.set("n", "<C-,>", "<cmd>BufferMovePrevious<CR>", { desc = "Move buffer left", })
      vim.keymap.set("n", "<C-.>", "<cmd>BufferMoveNext<CR>", { desc = "Move buffer right", })
    end,
    lazy = false,
  },

  {
    "kwkarlwang/bufjump.nvim",
    opts = {
      forward_key = "<M-i>",
      backward_key = "<M-o>",
    },
  },

  {
    "s1n7ax/nvim-window-picker",
    config = function()
      require("window-picker").setup({
        hint = "floating-big-letter",
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
      local function pick_window()
        vim.api.nvim_set_current_win(require("window-picker").pick_window() or vim.api.nvim_get_current_win())
      end
      vim.keymap.set("n", "<c-w>e", pick_window, { desc = "Pick window", })
      vim.keymap.set("n", "<c-w><c-e>", pick_window, { desc = "Pick window", })
    end,
  },

  {
    "sindrets/winshift.nvim",
    dependencies = {
      "s1n7ax/nvim-window-picker",
    },
    opts = {
      window_picker = function()
        return require("window-picker").pick_window()
      end,
    },
    keys = {
      {
        "<c-w>x",
        "<cmd>WinShift swap<cr>",
        desc = "Swap window",
      },
      {
        "<c-w><c-x>",
        "<cmd>WinShift swap<cr>",
        desc = "Swap window",
      },
    },
  },

  {
    "kevinhwang91/nvim-bqf",
    dependencies = {
      "junegunn/fzf",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("bqf").setup({
        preview = {
          auto_preview = false,
          winblend = 0,
          should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 1000 * 1024 then
              ret = false
            elseif bufname:match("^fugitive://") then
              ret = false
            end
            return ret
          end,
        },
        func_map = {
          tab = "",
          tabb = "",
          tabc = "",
          prevfile = "K",
          nextfile = "J",
          pscrollup = "<c-u>",
          pscrolldown = "<c-d>",
          ptoggleauto = "<c-p>",
        },
      })

      vim.api.nvim_create_autocmd("BufRead", {
        callback = function(ev)
          if vim.bo[ev.buf].buftype == "quickfix" then
            vim.schedule(function()
              vim.keymap.set("n", "<c-t>", function()
                vim.cmd([[cclose]])
                vim.cmd([[Trouble qflist open]])
              end, { buffer = ev.buf, desc = "Open quickfix list in Trouble", })

              vim.keymap.set("n", "zx", function()
                require("quicker").refresh()
              end, { buffer = ev.buf, desc = "Refresh quickfix list", })

              vim.keymap.set("n", "q", function()
                vim.cmd("cclose")
              end, { buffer = ev.buf, desc = "Close quickfix list", })
            end)
          end
        end,
      })
    end,
  },

  {
    "stevearc/quicker.nvim",
    config = function()
      require("quicker").setup({
        edit = {
          enabled = true,
          autosave = true,
        },
        highlight = {
          treesitter = true,
          lsp = false,
        },
      })
      vim.keymap.set("n", "<leader>q", function()
        require("quicker").toggle({
          focus = true,
        })
      end, { desc = "Toggle quickfix list", })
    end,
  },

  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        focus = true,
        auto_refresh = false,
        auto_preview = false,
        follow = false,
        win = {
          position = "bottom",
        },
        keys = {
          ["<c-x>"] = "jump_split",
          ["<c-s>"] = false,
        },
      })

      local function qf_next()
        if require("trouble").is_open() then
          require("trouble").next({
            skip_groups = true,
            jump = true,
          })
        else
          vim.cmd("silent! cnext")
        end
      end

      local function qf_prev()
        if require("trouble").is_open() then
          require("trouble").prev({
            skip_groups = true,
            jump = true,
          })
        else
          vim.cmd("silent! cprev")
        end
      end

      local function qf_first()
        if require("trouble").is_open() then
          require("trouble").first({
            jump = true,
          })
        else
          vim.cmd("cfirst")
        end
      end

      local function qf_last()
        if require("trouble").is_open() then
          require("trouble").last({
            jump = true,
          })
        else
          vim.cmd("clast")
        end
      end

      vim.keymap.set("n", "]q", qf_next, {silent = true, desc = "Next (Trouble/QF)"})
      vim.keymap.set("n", "[q", qf_prev, {silent = true, desc = "Prev (Trouble/QF)"})
      vim.keymap.set("n", "[Q", qf_first, {
        silent = true,
        desc = "First (Trouble/QF)",
      })
      vim.keymap.set("n", "]Q", qf_last, {
        silent = true,
        desc = "Last (Trouble/QF)",
      })
      vim.keymap.set("n", "<leader>T", function()
        require("trouble").toggle()
      end, { desc = "Toggle Trouble", })
    end,
  },

  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        disable_keymaps = true,
        filetypes_denylist = {
          "minipick",
          "TelescopePrompt",
          "trouble",
          "NvimTree",
          "oil",
          "aerial",
          "undotree",
          "fugitiveblame",
        },
      })
      vim.keymap.set("n", "[[", function()
        require("illuminate").goto_prev_reference()
      end, { desc = "Prev Reference", })
      vim.keymap.set("n", "]]", function()
        require("illuminate").goto_next_reference()
      end, { desc = "Next Reference", })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "▏",
      },
      scope = {
        enabled = false,
      },
    },
  },

  {
    "lukas-reineke/virt-column.nvim",
    opts = {
      char = "┊",
      highlight = "VirtColumn",
    },
  },

  {
    "sitiom/nvim-numbertoggle",
  },

  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({
        notification = {
          view = {
            stack_upwards = false,
          },
        },
      })
      vim.notify = require("fidget").notify
    end,
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    config = function()
      require("tiny-inline-diagnostic").setup({})
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
  },

  {
    "rachartier/tiny-code-action.nvim",
    opts = {},
    event = "LspAttach",
    keys = {
      {
        "g:",
        function()
          require("tiny-code-action").code_action()
        end,
        mode = { "n", "v" },
        desc = "Open LSP code action menu",
      },
    },
  },

  {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup({
        builtin_marks = { },
        default_mappings = false,
        mappings = {
          set = "m",
          set_next = "m,",
          toggle = "m;",
          delete = "dm",
          delete_line = "dm-",
        },
        excluded_filetypes = {
          "blink-cmp-menu",
          "dropbar_menu",
          "dropbar_menu_fzf",
          "DressingInput",
          "cmp_docs",
          "cmp_menu",
          "minipick",
          "noice",
          "prompt",
          "TelescopePrompt",
          "trouble",
          "NvimTree",
          "oil",
          "aerial",
          "undotree",
          "fugitiveblame",
          "diffview",
          "qf",
        },
      })
    end,
  },

  {
    "lewis6991/satellite.nvim",
    config = function()
      require("satellite").setup({
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
          "blink-cmp-menu",
          "dropbar_menu",
          "dropbar_menu_fzf",
          "DressingInput",
          "cmp_docs",
          "cmp_menu",
          "minipick",
          "noice",
          "prompt",
          "TelescopePrompt",
          "trouble",
          "NvimTree",
          "oil",
          "aerial",
          "undotree",
          "fugitiveblame",
          "diffview",
          "qf",
        },
      })
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      signs = false,
      merge_keywords = false,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE", }, },
        TODO = { icon = " ", color = "info", },
        HACK = { icon = " ", color = "warning", },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX", }, },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE", }, },
        NOTE = { icon = " ", color = "hint", alt = { "INFO", }, },
      },
      highlight = {
        comments_only = true,
        after = "empty",
      },
    },
    event = { "BufReadPost", "BufNewFile", },
    keys = {
      {
        "]n",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[n",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      {
        "<leader>n",
        "<cmd>TodoTelescope<CR>",
        desc = "Find todo comments",
      },
    },
  },

  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
        preset = "helix",
        icons = {
          mappings = false,
        },
        delay = function(ctx)
          return ctx.plugin and 0 or 500
        end,
        win = {
          no_overlap = false,
          width = 80,
        },
      })
      vim.keymap.set("n", "<leader>?", function()
        require("which-key").show()
      end, { desc = "Show keymaps", })
    end,
    event = "VeryLazy",
  },

}
