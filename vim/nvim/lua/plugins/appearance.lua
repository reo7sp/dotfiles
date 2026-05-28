return {

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
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
          render_markdown = true,
          telescope = {
            enabled = true,
          },
          lsp_trouble = true,
          illuminate = {
            enabled = true,
            lsp = false,
          },
          vim_sneak = true,
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
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "#e4e4e4" })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    config = function()
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

      local lualine = require("lualine")
      lualine.setup({
        options = {
          theme = "tomorrow",
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
          "nvim-tree",
          "oil",
          "aerial",
          "quickfix",
          "trouble",
          "fugitive",
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return str:sub(1, 1)
              end,
            },
          },
          lualine_b = {
          },
          lualine_c = {
            {
              "filename",
              path = 1,
              file_status = false,
            },
            {
              "aerial",
              depth = 3,
              sep = " > ",
              padding = {
                left = 0,
                right = 1,
              },
              cond = conditions.hide_in_width_last,
            },
          },
          lualine_x = {
            {
              "b:gitsigns_head",
              cond = conditions.hide_in_width_first,
            },
            {
              "diff",
              source = diff_source,
              padding = {
                left = 0,
                right = 1,
              },
              cond = conditions.hide_in_width_middle,
            },
            {
              "filetype",
              cond = conditions.hide_in_width_middle,
            },
            {
              "lsp_status",
              symbols = {
                done = "",
              },
              padding = {
                left = 0,
                right = 1,
              },
              cond = conditions.hide_in_width_middle,
            },
            {
              "diagnostics",
              padding = {
                left = 0,
                right = 1,
              },
              cond = conditions.hide_in_width_last,
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
              cond = conditions.hide_in_width_last
            },
            {
              require("minuet.lualine"),
            },
          },
          lualine_y = {
          },
          lualine_z = {
            "location",
            "searchcount",
            "selectioncount",
          },
        },
        inactive_sections = {
          lualine_a = {
          },
          lualine_b = {
          },
          lualine_c = {
            {
              "filename",
              path = 1,
              file_status = false,
            },
          },
          lualine_x = {
            "location",
          },
          lualine_y = {
          },
          lualine_z = {
          },
        },
      })

      local bg = "#C8C8C8"
      local fg = "#666666"
      for _, grp in ipairs({
        "lualine_a_inactive","lualine_b_inactive","lualine_c_inactive",
        "lualine_x_inactive","lualine_y_inactive","lualine_z_inactive",
      }) do
        vim.api.nvim_set_hl(0, grp, {
          bg = bg,
          fg = fg,
        })
      end

      vim.o.fillchars = "vert:┃"
      vim.api.nvim_set_hl(0, "WinSeparator", {
        fg = bg,
        bold = true,
      })
      vim.cmd([=[
        set noruler
      ]=])
    end,
  },

  {
    "romgrk/barbar.nvim",
    lazy = false,
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
            filename = true,
            separator = {
              right = " ★ ",
            },
          },
          separator_at_end = false,
        },
        minimum_padding = 0,
        maximum_padding = 0,
        sidebar_filetypes = {},
        no_name_title = "[No Name]",
      })
      vim.api.nvim_set_hl(0, "BufferCurrentMod", { link = "BufferCurrent" })
      vim.api.nvim_set_hl(0, "BufferInactiveMod", { link = "BufferInactive" })
      vim.cmd([=[
        cnoreabbrev bq BufferClose
        cnoreabbrev bd BufferClose
        cnoreabbrev bo BufferCloseAllButCurrentOrPinned
        cnoreabbrev bon BufferCloseAllButCurrentOrPinned
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
      vim.keymap.set("n", "[b", "<cmd>BufferPrevious<CR>")
      vim.keymap.set("n", "]b", "<cmd>BufferNext<CR>")
      for i = 1, 8 do
        vim.keymap.set("n", "<C-" .. i .. ">", "<cmd>BufferGoto " .. i .. "<CR>")
      end
      vim.keymap.set("n", "<C-9>", "<cmd>BufferLast<CR>")
      vim.keymap.set("n", "<c-q>", "<cmd>BufferClose<cr>")
      vim.keymap.set("n", "<c-w>Q", "<cmd>BufferClose<cr>")
      vim.keymap.set("n", "<c-w>O", "<cmd>BufferCloseAllButCurrentOrPinned<cr>")
      vim.keymap.set("n", "<C-,>", "<cmd>BufferMovePrevious<CR>")
      vim.keymap.set("n", "<C-.>", "<cmd>BufferMoveNext<CR>")
    end,
  },

  {
    "leath-dub/snipe.nvim",
    dependencies = {
      "romgrk/barbar.nvim",
    },
    opts = {
      ui = {
        preselect_current = true,
        open_win_override = {
          border = "rounded",
        },
      },
      navigate = {
        leader = " ",
      },
      sort = function(buffers)
        local index_of = require("barbar.utils.list").index_of
        local state = require("barbar.state")
        local barbar_buffers = state.buffers or {}
        table.sort(buffers, function(a, b)
          local ai = index_of(barbar_buffers, a.id) or math.huge
          local bi = index_of(barbar_buffers, b.id) or math.huge
          if ai == bi then
            return a.id < b.id
          end
          return ai < bi
        end)
        return buffers
      end,
    },
    keys = {
      {
        "<C-Tab>",
        function()
          require("snipe").open_buffer_menu()
        end,
      },
    },
  },

  {
    "reo7sp/snipe-marks.nvim",
    dependencies = {
      "leath-dub/snipe.nvim",
    },
    keys = {
      {
        "<C-S-Tab>",
        function()
          require("snipe-marks").open_marks_menu("all")
        end,
      },
    },
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
      vim.keymap.set("n", "<c-w>e", pick_window)
      vim.keymap.set("n", "<c-w><c-e>", pick_window)
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
      },
      {
        "<c-w><c-x>",
        "<cmd>WinShift swap<cr>",
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
              end, { buffer = ev.buf, })

              vim.keymap.set("n", "zx", function()
                require("quicker").refresh()
              end, { buffer = ev.buf, })

              vim.keymap.set("n", "q", function()
                vim.cmd("cclose")
              end, { buffer = ev.buf, })
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
        type_icons = {
          E = "E",
          W = "W",
          I = "I",
          N = "N",
          H = "H",
        },
      })
      vim.keymap.set("n", "<leader>q", function()
        require("quicker").toggle({
          focus = true,
        })
      end)
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
        icons = {
          indent = {
            fold_open     = "  ",
            fold_closed   = "  ",
          },
          folder_closed   = "",
          folder_open     = "",
          kinds = {
            Array         = "",
            Boolean       = "",
            Class         = "",
            Constant      = "",
            Constructor   = "",
            Enum          = "",
            EnumMember    = "",
            Event         = "",
            Field         = "",
            File          = "",
            Function      = "",
            Interface     = "",
            Key           = "",
            Method        = "",
            Module        = "",
            Namespace     = "",
            Null          = "",
            Number        = "",
            Object        = "",
            Operator      = "",
            Package       = "",
            Property      = "",
            String        = "",
            Struct        = "",
            TypeParameter = "",
            Variable      = "",
          },
        },
      })

      local function qf_next()
        if require("trouble").is_open() then
          require("trouble").next({
            skip_groups = true,
            jump = true,
          })
        else
          vim.cmd("cnext")
        end
      end

      local function qf_prev()
        if require("trouble").is_open() then
          require("trouble").prev({
            skip_groups = true,
            jump = true,
          })
        else
          vim.cmd("cprev")
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
      vim.api.nvim_set_hl(0, "TroubleNormal", { link = "Normal" })
      vim.api.nvim_set_hl(0, "TroubleNormalNC", { link = "Normal" })
      vim.api.nvim_set_hl(0, "TroubleIndent", { link = "IblIndent" })
      vim.api.nvim_set_hl(0, "TroubleIndentFoldClosed", { link = "IblIndent" })
      vim.api.nvim_set_hl(0, "TroubleIndentFoldOpen", { link = "IblIndent" })
      vim.keymap.set("n", "<leader>T", function()
        require("trouble").toggle()
      end)
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      signs = false,
      keywords = {
        FIX = {
          icon = "",
        },
        TODO = {
          icon = "",
        },
        HACK = {
          icon = "",
        },
        WARN = {
          icon = "",
        },
        PERF = {
          icon = "",
        },
        NOTE = {
          icon = "",
        },
        TEST = {
          icon = "",
        },
      },
      highlight = {
        comments_only = true,
        after = "empty",
      },
    },
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
      vim.api.nvim_set_hl(0, "MarkSignHL", { link = "SignColumn" })
      vim.api.nvim_set_hl(0, "MarkSignNumHL", { link = "SignColumn" })
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
      vim.api.nvim_set_hl(0, "SatelliteSearch", { link = "SatelliteMark" })
      vim.api.nvim_set_hl(0, "SatelliteSearchCurrent", { link = "SatelliteMark" })
    end,
  },

  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        disable_keymaps = true,
        filetypes_denylist = {
          "TelescopePrompt",
          "trouble",
          "NvimTree",
          "oil",
          "aerial",
          "undotree",
          "fugitiveblame",
        },
      })
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
      char = "╎",
      highlight = "IblIndent",
    },
  },

  {
    "sitiom/nvim-numbertoggle",
  },

  {
    "mawkler/hml.nvim",
    opts = {},
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    config = function()
      require("tiny-inline-diagnostic").setup({})
      vim.diagnostic.config({
        virtual_text = false,
      })
      vim.api.nvim_set_hl(0, "TinyInlineDiagnosticVirtualTextArrow", { link = "CursorLine" })
    end,
  },

  {
    "rachartier/tiny-code-action.nvim",
    event = "LspAttach",
    opts = {
      signs = {
        quickfix = {
          "",
          {
            link = "DiagnosticWarning",
          },
        },
        others = {
          "",
          {
            link = "DiagnosticWarning",
          },
        },
        refactor = {
          "",
          {
            link = "DiagnosticInfo",
          },
        },
        ["refactor.move"] = {
          "",
          {
            link = "DiagnosticInfo",
          },
        },
        ["refactor.extract"] = {
          "",
          {
            link = "DiagnosticError",
          },
        },
        ["source.organizeImports"] = {
          "",
          {
            link = "DiagnosticWarning",
          },
        },
        ["source.fixAll"] = {
          "",
          {
            link = "DiagnosticError",
          },
        },
        ["source"] = {
          "",
          {
            link = "DiagnosticError",
          },
        },
        ["rename"] = {
          "",
          {
            link = "DiagnosticWarning",
          },
        },
        ["codeAction"] = {
          "",
          {
            link = "DiagnosticWarning",
          },
        },
      },
    },
    keys = {
      {
        "g:",
        function()
          require("tiny-code-action").code_action()
        end,
        mode = { "n", "v" },
      },
    },
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
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        preset = "helix",
        delay = function(ctx)
          return ctx.plugin and 0 or 500
        end,
        win = {
          no_overlap = false,
          width = 80,
        },
        icons = {
          mappings = false,
          keys = {
            Up = "<Up>",
            Down = "<Down>",
            Left = "<Left>",
            Right = "<Right>",
            C = "<C>",
            M = "<M>",
            D = "<D>",
            S = "<S>",
            CR = "<CR>",
            Esc = "<Esc>",
            ScrollWheelDown = "<ScrollWheelDown>",
            ScrollWheelUp = "<ScrollWheelUp>",
            NL = "<NL>",
            BS = "<BS>",
            Space = "<Space>",
            Tab = "<Tab>",
            F1 = "<F1>",
            F2 = "<F2>",
            F3 = "<F3>",
            F4 = "<F4>",
            F5 = "<F5>",
            F6 = "<F6>",
            F7 = "<F7>",
            F8 = "<F8>",
            F9 = "<F9>",
            F10 = "<F10>",
            F11 = "<F11>",
            F12 = "<F12>",
          },
        },
      })
      vim.keymap.set("n", "<leader>?", function()
        require("which-key").show()
      end)
    end,
  },

}
