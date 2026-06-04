return {

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      local lsp_configs = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
          },
        },
        gopls = {
          cmd = {
            vim.fn.stdpath("config") .. "/bin/custom-gopls",
          },
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
                  "vim",
                  "box",
                },
              },
            },
          },
        },
      }
      for server_name, config in pairs(lsp_configs) do
        vim.lsp.config(server_name, config)
      end

      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show LSP hover", })
      vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, { desc = "Show LSP signature help", })
      vim.keymap.set("n", "gr", vim.lsp.buf.rename, { nowait = true, desc = "Rename symbol", })
      vim.keymap.set("n", "gO", "<nop>")
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {},
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local lsps = {
        "clangd",
        "gopls",
        "pyright",
        "perlnavigator",
        "lua_ls",
        "bashls",
        "html",
        "cssls",
        "ts_ls",
        "jinja_lsp",
        "jsonls",
        "yamlls",
        "lemminx",
        "protols",
      }
      require("mason-lspconfig").setup({
        ensure_installed = lsps,
      })
    end,
  },

  {
    "RubixDev/mason-update-all",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {},
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
    event = "InsertEnter",
  },

  {
    "rafamadriz/friendly-snippets",
  },

  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      local preset_configs = {
        ["local"] = {
          provider = "openai_fim_compatible",
          provider_options = {
            openai_fim_compatible = {
              name = "local",
              end_point = "http://localhost:11434/v1/completions",
              api_key = "TERM",
              stream = true,
              model = "qwen2.5-coder:3b",
              optional = {
                max_tokens = 64,
                top_p = 0.9,
              },
            },
          },
        },
        remote = {
          provider = "openai_compatible",
          provider_options = {
            openai_compatible = vim.tbl_extend("force", {
              name = "remote",
            }, require("configs.custom_minuet_llm")),
          },
        },
      }
      require("minuet").setup({
        presets = preset_configs,
        blink = {
          enable_auto_complete = false,
        },
        n_completions = 1,
        context_window = 1024,
        request_timeout = 3,
      })

      local default_preset = "local"
      if preset_configs["remote"]
          and preset_configs["remote"]["provider_options"]
          and preset_configs["remote"]["provider_options"]["openai_compatible"]
          and preset_configs["remote"]["provider_options"]["openai_compatible"]["end_point"] then
        default_preset = "remote"
      end
      require("minuet").config = vim.tbl_deep_extend("force", require("minuet").config, preset_configs[default_preset])
      vim.keymap.set("n", "<leader>=", function()
        if require("minuet").config["blink"].enable_auto_complete then
          vim.cmd("Minuet blink disable")
        else
          vim.cmd("Minuet blink enable")
        end
      end, { desc = "Toggle LLM auto completion", })
    end,
    event = "InsertEnter",
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
    "xzbdmw/colorful-menu.nvim",
    opts = {},
    event = "InsertEnter",
  },

  {
    "saghen/blink.cmp",
    version = "v1.*",
    dependencies = {
      "xzbdmw/colorful-menu.nvim",
      "milanglacier/minuet-ai.nvim",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("blink.cmp").setup({
        keymap = {
          preset = "super-tab",
          ["<CR>"] = {
            "accept",
            "fallback",
          },
          ["<C-y>"] = require("minuet").make_blink_map(),
        },
        sources = {
          default = {
            "lsp",
            "path",
            "buffer",
            "snippets",
            "minuet",
          },
          providers = {
            minuet = {
              name = "minuet",
              module = "minuet.blink",
              async = true,
              timeout_ms = 3000,
              score_offset = 50,
            },
          },
        },
        snippets = {
          preset = "luasnip",
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
              columns = {
                {
                  "label",
                  gap = 1,
                },
                {
                  "kind",
                },
              },
              components = {
                label = {
                  text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
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
    end,
    event = "InsertEnter",
  },

  {
    "windwp/nvim-autopairs",
    opts = {},
    event = "InsertEnter",
  },

  {
    "alvan/vim-closetag",
    ft = {
      "html",
      "htm",
      "xml",
      "js",
      "jsx",
      "ts",
      "tsx",
    },
  },

  {
    "haya14busa/vim-asterisk",
    init = function()
      vim.cmd([[
        let g:asterisk#keeppos = 1
      ]])
    end,
    config = function()
      vim.keymap.set("", "*", "<Plug>(asterisk-*)", { remap = true, desc = "Search word forward", })
      vim.keymap.set("", "#", "<Plug>(asterisk-#)", { remap = true, desc = "Search word backward", })
      vim.keymap.set("", "g*", "<Plug>(asterisk-g*)", { remap = true, desc = "Search partial word forward", })
      vim.keymap.set("", "g#", "<Plug>(asterisk-g#)", { remap = true, desc = "Search partial word backward", })
      vim.keymap.set("", "z*", "<Plug>(asterisk-z*)", { remap = true, desc = "Search word forward from start", })
      vim.keymap.set("", "gz*", "<Plug>(asterisk-gz*)", { remap = true, desc = "Search partial word forward from start", })
      vim.keymap.set("", "z#", "<Plug>(asterisk-z#)", { remap = true, desc = "Search word backward from start", })
      vim.keymap.set("", "gz#", "<Plug>(asterisk-gz#)", { remap = true, desc = "Search partial word backward from start", })
    end,
    keys = {
      { "*", desc = "Search word forward", },
      { "#", desc = "Search word backward", },
      { "g*", desc = "Search partial word forward", },
      { "g#", desc = "Search partial word backward", },
      { "z*", desc = "Search word forward from start", },
      { "gz*", desc = "Search partial word forward from start", },
      { "z#", desc = "Search word backward from start", },
      { "gz#", desc = "Search partial word backward from start", },
    },
  },

  {
    "wellle/targets.vim",
  },

  {
    "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y-%m-%d"],
          augend.constant.alias.bool,
          augend.constant.new({
            elements = {
              "and",
              "or",
            },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = {
              "&&",
              "||",
            },
            word = false,
            cyclic = true,
          }),
        },
      })
      vim.keymap.set("n", "<C-a>", "<Plug>(dial-increment)", { remap = true, desc = "Increment", })
      vim.keymap.set("n", "<C-x>", "<Plug>(dial-decrement)", { remap = true, desc = "Decrement", })
      vim.keymap.set("n", "g<C-a>", "g<Plug>(dial-increment)", { remap = true, desc = "Increment sequence", })
      vim.keymap.set("n", "g<C-x>", "g<Plug>(dial-decrement)", { remap = true, desc = "Decrement sequence", })
      vim.keymap.set("v", "<C-a>", "<Plug>(dial-increment)", { remap = true, desc = "Increment", })
      vim.keymap.set("v", "<C-x>", "<Plug>(dial-decrement)", { remap = true, desc = "Decrement", })
      vim.keymap.set("v", "g<C-a>", "g<Plug>(dial-increment)", { remap = true, desc = "Increment sequence", })
      vim.keymap.set("v", "g<C-x>", "g<Plug>(dial-decrement)", { remap = true, desc = "Decrement sequence", })
    end,
    keys = {
      {
        "<C-a>",
        mode = { "n", "v" },
        desc = "Increment",
      },
      {
        "<C-x>",
        mode = { "n", "v" },
        desc = "Decrement",
      },
      {
        "g<C-a>",
        mode = { "n", "v" },
        desc = "Increment sequence",
      },
      {
        "g<C-x>",
        mode = { "n", "v" },
        desc = "Decrement sequence",
      },
    },
  },

  {
    "romainl/vim-cool",
  },

  {
    "keaising/im-select.nvim",
    main = "im_select",
    opts = {
      default_im_select = "com.apple.keylayout.ABC",
      keep_quiet_on_no_binary = true,
    },
    event = "InsertEnter",
  },

  {
    "nmac427/guess-indent.nvim",
    opts = {},
    event = "BufReadPre",
  },

  {
    "lewis6991/spaceless.nvim",
  },

  {
    "ntpeters/vim-better-whitespace",
    init = function()
      vim.cmd([=[
        let g:better_whitespace_enabled = 0
        let g:better_whitespace_operator = ''
        let g:strip_max_file_size = 99999
        let g:strip_whitespace_confirm = 0
      ]=])
    end,
    cmd = {
      "EnableWhitespace",
      "DisableWhitespace",
      "ToggleWhitespace",
      "StripWhitespace",
      "NextTrailingWhitespace",
      "PrevTrailingWhitespace",
    },
    keys = {
      {
        "]w",
        "<cmd>NextTrailingWhitespace<CR>",
        desc = "Next trailing whitespace",
      },
      {
        "[w",
        "<cmd>PrevTrailingWhitespace<CR>",
        desc = "Previous trailing whitespace",
      },
    },
  },

  {
    "justinmk/vim-sneak",
    init = function()
      vim.cmd([=[
        let g:sneak#use_ic_scs = 1
      ]=])
    end,
    config = function()
      vim.keymap.set("n", "s", "<Plug>Sneak_s", { remap = true, desc = "Sneak forward", })
      vim.keymap.set("n", "S", "<Plug>Sneak_S", { remap = true, desc = "Sneak backward", })
      vim.keymap.set("x", "s", "<Plug>Sneak_s", { remap = true, desc = "Sneak forward", })
      vim.keymap.set("x", "Z", "<Plug>Sneak_S", { remap = true, desc = "Sneak backward", })
      vim.keymap.set("o", "z", "<Plug>Sneak_s", { remap = true, desc = "Sneak forward", })
      vim.keymap.set("o", "Z", "<Plug>Sneak_S", { remap = true, desc = "Sneak backward", })
      vim.keymap.set({ "n", "x", "o" }, ";", "<Plug>Sneak_;", { remap = true, desc = "Repeat Sneak forward", })
      vim.keymap.set({ "n", "x", "o" }, ",", "<Plug>Sneak_,", { remap = true, desc = "Repeat Sneak backward", })
      vim.keymap.set("", "f", "<Plug>Sneak_f", { remap = true, desc = "Find character forward", })
      vim.keymap.set("", "F", "<Plug>Sneak_F", { remap = true, desc = "Find character backward", })
      vim.keymap.set("", "t", "<Plug>Sneak_t", { remap = true, desc = "Till character forward", })
      vim.keymap.set("", "T", "<Plug>Sneak_T", { remap = true, desc = "Till character backward", })
    end,
    keys = {
      {
        "s",
        mode = { "n", "x" },
        desc = "Sneak forward",
      },
      {
        "S",
        mode = "n",
        desc = "Sneak backward",
      },
      {
        "z",
        mode = "o",
        desc = "Sneak forward",
      },
      {
        "Z",
        mode = { "x", "o" },
        desc = "Sneak backward",
      },
      {
        ";",
        mode = { "n", "x", "o" },
        desc = "Repeat sneak forward",
      },
      {
        ",",
        mode = { "n", "x", "o" },
        desc = "Repeat sneak backward",
      },
      {
        "f",
        mode = { "n", "x", "o" },
        desc = "Find character forward",
      },
      {
        "F",
        mode = { "n", "x", "o" },
        desc = "Find character backward",
      },
      {
        "t",
        mode = { "n", "x", "o" },
        desc = "Till character forward",
      },
      {
        "T",
        mode = { "n", "x", "o" },
        desc = "Till character backward",
      },
    },
  },

  {
    "rlane/pounce.nvim",
    opts = {},
    keys = {
      {
        "<leader><leader>",
        function()
          require("pounce").pounce({})
        end,
        mode = { "n", "x", "o" },
        desc = "Pounce",
      },
    },
  },

  {
    "kylechui/nvim-surround",
    opts = {
      move_cursor = false,
    },
    event = "InsertEnter",
  },

  {
    "gbprod/substitute.nvim",
    opts = {
      range = {
        prefix = "x",
      },
    },
    keys = {
      {
        "x",
        function()
          require("substitute").operator()
        end,
        mode = "n",
        desc = "Substitute with register",
      },
      {
        "xx",
        function()
          require("substitute").line()
        end,
        mode = "n",
        desc = "Substitute line with register",
      },
      {
        "X",
        function()
          require("substitute").eol()
        end,
        mode = "n",
        desc = "Substitute to end of line with register",
      },
      {
        "x",
        function()
          require("substitute").visual()
        end,
        mode = "x",
        desc = "Substitute selection with register",
      },
    },
  },

  {
    "chrishrb/gx.nvim",
    submodules = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    init = function()
      vim.g.netrw_nogx = 1
    end,
    opts = {},
    keys = {
      {
        "gx",
        "<cmd>Browse<cr>",
        mode = { "n", "x" },
        desc = "Open URL",
      },
    },
    cmd = {
      "Browse",
    },
  },

  {
    "ysmb-wtsg/in-and-out.nvim",
    event = "InsertEnter",
    keys = {
      {
        "<C-CR>",
        function()
          require("in-and-out").in_and_out()
        end,
        mode = "i",
        desc = "Jump in or out of brackets",
      },
    },
  },

  {
    "gbprod/yanky.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
    },
    opts = {
      ring = {
        storage = "sqlite",
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
    },
    keys = {
      {
        "y",
        "<Plug>(YankyYank)",
        mode = { "n", "x" },
        desc = "Yank text",
      },
      {
        "p",
        "<Plug>(YankyPutAfter)",
        mode = { "n", "x" },
        desc = "Put after",
      },
      {
        "P",
        "<Plug>(YankyPutBefore)",
        mode = { "n", "x" },
        desc = "Put before",
      },
      {
        "gp",
        "<Plug>(YankyGPutAfter)",
        mode = { "n", "x" },
        desc = "Put after and move cursor",
      },
      {
        "gP",
        "<Plug>(YankyGPutBefore)",
        mode = { "n", "x" },
        desc = "Put before and move cursor",
      },
      {
        "]p",
        "<Plug>(YankyPutIndentAfterLinewise)",
        desc = "Put after with linewise indent",
      },
      {
        "[p",
        "<Plug>(YankyPutIndentBeforeLinewise)",
        desc = "Put before with linewise indent",
      },
      {
        "]P",
        "<Plug>(YankyPutIndentAfterLinewise)",
        desc = "Put after with linewise indent",
      },
      {
        "[P",
        "<Plug>(YankyPutIndentBeforeLinewise)",
        desc = "Put before with linewise indent",
      },
      {
        ">p",
        "<Plug>(YankyPutIndentAfterShiftRight)",
        desc = "Put after and indent right",
      },
      {
        "<p",
        "<Plug>(YankyPutIndentAfterShiftLeft)",
        desc = "Put after and indent left",
      },
      {
        ">P",
        "<Plug>(YankyPutIndentBeforeShiftRight)",
        desc = "Put before and indent right",
      },
      {
        "<P",
        "<Plug>(YankyPutIndentBeforeShiftLeft)",
        desc = "Put before and indent left",
      },
      {
        "=p",
        "<Plug>(YankyPutAfterFilter)",
        desc = "Put after and reindent",
      },
      {
        "=P",
        "<Plug>(YankyPutBeforeFilter)",
        desc = "Put before and reindent",
      },
      {
        "iy",
        function()
          require("yanky.textobj").last_put()
        end,
        mode = { "o", "x" },
        desc = "Last put text object",
      },
      {
        "[y",
        "<Plug>(YankyPreviousEntry)",
        desc = "Previous yank history entry",
      },
      {
        "]y",
        "<Plug>(YankyNextEntry)",
        desc = "Next yank history entry",
      },
    },
  },

  {
    "mbbill/undotree",
    init = function()
      vim.cmd([=[
        let g:undotree_WindowLayout = 3
        let g:undotree_SetFocusWhenToggle = 1
        let g:undotree_SplitWidth = 80
      ]=])
    end,
    cmd = "UndotreeToggle",
    keys = {
      {
        "<leader>u",
        "<cmd>UndotreeToggle<cr>",
        desc = "Toggle undo tree",
      },
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
      vim.o.foldlevel = 999
      vim.o.foldlevelstart = 999
      vim.o.foldenable = true

      require("ufo").setup({
        open_fold_hl_timeout = 0,
        provider_selector = function(bufnr, filetype, buftype)
          return { "indent" }
        end
      })

      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds", })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds", })
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds", })
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with level", })
    end,
  },

  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      pre_hook = function(...)
        return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(...)
      end,
    },
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enable_autocmd = false,
    },
  },

  {
    "Wansmer/treesj",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 9999,
    },
    keys = {
      {
        "gm",
        function()
          require("treesj").toggle()
        end,
        desc = "Toggle split or join",
      },
      {
        "gM",
        "<nop>",
      },
    },
  },

  {
    "johmsalas/text-case.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("textcase").setup({
        prefix = "gt",
      })
      vim.keymap.set("n", "gT", "<nop>")
    end,
  },

  {
    "echasnovski/mini.align",
    opts = {
      mappings = {
        start = "",
        start_with_preview = "ga",
      },
    },
    keys = {
      {
        "ga",
        mode = { "n", "x" },
        desc = "Align with preview",
      },
    },
  },

  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "lewis6991/async.nvim",
    },
    opts = {},
    keys = {
      {
        "gR",
        function()
          require("refactoring").select_refactor()
        end,
        mode = { "n", "x" },
        desc = "Refactor",
      },
    },
  },

  {
    "danymat/neogen",
    opts = {},
    cmd = "Neogen",
  },

  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          c = {
            "clang_format",
          },
          cpp = {
            "clang_format",
          },
          go = {
            "goimports",
            "gofmt",
          },
          python = {
            "isort",
            "black",
          },
          lua = {
            "stylua",
          },
          html = {
            "prettier",
          },
          css = {
            "prettier",
          },
          javascript = {
            "prettier",
          },
          typescript = {
            "prettier",
          },
          tsx = {
            "prettier",
          },
          jsx = {
            "prettier",
          },
          sh = {
            "shfmt",
          },
          json = {
            "jq",
          },
          yaml = {
            "yamlfmt",
          },
        },
        default_format_opts = {
          timeout_ms = 10000,
          lsp_format = "fallback",
        },
      })
      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = {
              args.line1,
              0,
            },
            ["end"] = {
              args.line2,
              end_line:len(),
            },
          }
        end
        require("conform").format({
          async = true,
          lsp_format = "fallback",
          range = range,
        })
      end, { range = true, })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          vim.api.nvim_buf_set_option(args.buf, "formatexpr", "v:lua.require(\"conform\").formatexpr()")
        end,
      })
      vim.keymap.set("n", "gQ", function()
        require("conform").format({})
      end, { desc = "Format buffer", })
    end,
  },

  {
    "chrisbra/NrrwRgn",
    cmd = {
      "NR",
      "NRP",
      "NRM",
      "NW",
      "NRV",
      "NUD",
      "NRN",
      "NRS",
      "NRMulti",
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      vim.keymap.set({ "n", "v" }, "gh", "<nop>")
      vim.keymap.set({ "n", "v" }, "gH", "<nop>")
      require("gitsigns").setup({
        sign_priority = 100,
        trouble = false,
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          map("n", "]h", function()
            if vim.wo.diff then
              vim.cmd.normal({
                "]h",
                bang = true,
              })
            else
              gitsigns.nav_hunk("next")
            end
          end, { desc = "Next git hunk", })
          map("n", "[h", function()
            if vim.wo.diff then
              vim.cmd.normal({
                "[h",
                bang = true,
              })
            else
              gitsigns.nav_hunk("prev")
            end
          end, { desc = "Prev git hunk", })

          map("n", "]H", function()
            require("gitsigns").nav_hunk("next", {
              target = "staged",
            })
          end, { desc = "Next staged hunk", })
          map("n", "[H", function()
            require("gitsigns").nav_hunk("prev", {
              target = "staged",
            })
          end, { desc = "Prev staged hunk", })

          map({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<CR>", { desc = "Git hunk text object", })

          map("n", "gh", require("gitsigns").stage_hunk, { desc = "Stage/unstage git hunk", })
          map("v", "gh", function()
            require("gitsigns").stage_hunk({
              vim.fn.line("."),
              vim.fn.line("v"),
            })
          end, { desc = "Stage/unstage git hunk", })

          map("n", "gH", require("gitsigns").reset_hunk, { desc = "Discard git hunk", })
          map("v", "gH", function()
            require("gitsigns").reset_hunk({
              vim.fn.line("."),
              vim.fn.line("v"),
            })
          end, { desc = "Discard git hunk", })
        end
      })
      vim.keymap.set("n", "<c-w>g", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame current line", })
      vim.keymap.set("n", "<c-w><c-g>", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame current line", })
      vim.keymap.set("n", "<leader>gh", function()
        vim.cmd("Gitsigns blame")
        vim.defer_fn(function()
          vim.cmd("wincmd w")
        end, 200)
      end, { silent = true, desc = "Open git blame", })
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    opts = {
      disable_diagnostics = true,
    },
  },

}
