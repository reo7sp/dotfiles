return {

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "RubixDev/mason-update-all",
      "saghen/blink.cmp",
    },
    config = function()
      local lspconfig_defaults = require("lspconfig").util.default_config
      lspconfig_defaults.capabilities = vim.tbl_deep_extend(
        "force",
        lspconfig_defaults.capabilities,
        require("blink.cmp").get_lsp_capabilities({}, false)
      )

      require("mason").setup({})

      local lsps = {
        "clangd",
        "cmake",
        "gopls",
        "pyright",
        "perlnavigator",
        "lua_ls",
        "rust_analyzer",
        "bashls",
        "html",
        "cssls",
        "ts_ls",
        "jinja_lsp",
        "sqlls",
        "jsonls",
        "yamlls",
        "lemminx",
        "dockerls",
        "docker_compose_language_service",
        "ansiblels",
        "puppet",
        "gh_actions_ls",
        "gitlab_ci_ls",
      }
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
      require("mason-lspconfig").setup({
        ensure_installed = lsps,
      })

      require("mason-update-all").setup({})

      vim.keymap.set("n", "K", vim.lsp.buf.hover)
      vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help)
      vim.keymap.set("n", "gr", vim.lsp.buf.rename, { nowait = true, })
      vim.keymap.set("n", "gO", "<nop>")
    end,
  },

  {
    "williamboman/mason.nvim",
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
  },

  {
    "RubixDev/mason-update-all",
    dependencies = {
      "williamboman/mason.nvim",
    },
  },

  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  {
    "rafamadriz/friendly-snippets",
  },

  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
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
      end)
    end,
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
      },
      {
        "<leader>c",
        function()
          require("sidekick.cli").send({ msg = "{file}: ```{selection}``` " })
        end,
        mode = "v",
      },
    },
  },

  {
    "xzbdmw/colorful-menu.nvim",
  },

  {
    "saghen/blink.cmp",
    version = "v1.*",
    event = "InsertEnter",
    dependencies = {
      "xzbdmw/colorful-menu.nvim",
      "milanglacier/minuet-ai.nvim",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("colorful-menu").setup({})

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
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
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
    config = function()
      vim.cmd([[
        let g:asterisk#keeppos = 1
      ]])

      vim.keymap.set("", "*", "<Plug>(asterisk-*)", { remap = true, })
      vim.keymap.set("", "#", "<Plug>(asterisk-#)", { remap = true, })
      vim.keymap.set("", "g*", "<Plug>(asterisk-g*)", { remap = true, })
      vim.keymap.set("", "g#", "<Plug>(asterisk-g#)", { remap = true, })
      vim.keymap.set("", "z*", "<Plug>(asterisk-z*)", { remap = true, })
      vim.keymap.set("", "gz*", "<Plug>(asterisk-gz*)", { remap = true, })
      vim.keymap.set("", "z#", "<Plug>(asterisk-z#)", { remap = true, })
      vim.keymap.set("", "gz#", "<Plug>(asterisk-gz#)", { remap = true, })
    end,
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
      vim.keymap.set("n", "<C-a>", "<Plug>(dial-increment)", { remap = true, })
      vim.keymap.set("n", "<C-x>", "<Plug>(dial-decrement)", { remap = true, })
      vim.keymap.set("n", "g<C-a>", "g<Plug>(dial-increment)", { remap = true, })
      vim.keymap.set("n", "g<C-x>", "g<Plug>(dial-decrement)", { remap = true, })
      vim.keymap.set("v", "<C-a>", "<Plug>(dial-increment)", { remap = true, })
      vim.keymap.set("v", "<C-x>", "<Plug>(dial-decrement)", { remap = true, })
      vim.keymap.set("v", "g<C-a>", "g<Plug>(dial-increment)", { remap = true, })
      vim.keymap.set("v", "g<C-x>", "g<Plug>(dial-decrement)", { remap = true, })
    end,
  },

  {
    "romainl/vim-cool",
  },

  {
    "keaising/im-select.nvim",
    event = "InsertEnter",
    main = "im_select",
    opts = {
      default_im_select = "com.apple.keylayout.ABC",
      keep_quiet_on_no_binary = true,
    },
  },

  {
    "nmac427/guess-indent.nvim",
    opts = {},
  },

  {
    "lewis6991/spaceless.nvim",
  },

  {
    "ntpeters/vim-better-whitespace",
    config = function()
      vim.cmd([=[
        let g:better_whitespace_enabled = 0
        let g:better_whitespace_operator = ''
        let g:strip_max_file_size = 99999
        let g:strip_whitespace_confirm = 0
      ]=])
      vim.keymap.set("n", "]w", "<cmd>NextTrailingWhitespace<CR>")
      vim.keymap.set("n", "[w", "<cmd>PrevTrailingWhitespace<CR>")
    end,
  },

  {
    "justinmk/vim-sneak",
    init = function()
      vim.cmd([=[
        let g:sneak#use_ic_scs = 1
      ]=])
    end,
    config = function()
      vim.keymap.set("", "f", "<Plug>Sneak_f", { remap = true, })
      vim.keymap.set("", "F", "<Plug>Sneak_F", { remap = true, })
      vim.keymap.set("", "t", "<Plug>Sneak_t", { remap = true, })
      vim.keymap.set("", "T", "<Plug>Sneak_T", { remap = true, })
    end,
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
      },
    },
  },

  {
    "kylechui/nvim-surround",
    opts = {
      move_cursor = false,
    },
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
      },
      {
        "xx",
        function()
          require("substitute").line()
        end,
        mode = "n",
      },
      {
        "X",
        function()
          require("substitute").eol()
        end,
        mode = "n",
      },
      {
        "x",
        function()
          require("substitute").visual()
        end,
        mode = "x",
      },
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
      },
      {
        "p",
        "<Plug>(YankyPutAfter)",
        mode = { "n", "x" },
      },
      {
        "P",
        "<Plug>(YankyPutBefore)",
        mode = { "n", "x" },
      },
      {
        "gp",
        "<Plug>(YankyGPutAfter)",
        mode = { "n", "x" },
      },
      {
        "gP",
        "<Plug>(YankyGPutBefore)",
        mode = { "n", "x" },
      },
      {
        "]p",
        "<Plug>(YankyPutIndentAfterLinewise)",
      },
      {
        "[p",
        "<Plug>(YankyPutIndentBeforeLinewise)",
      },
      {
        "]P",
        "<Plug>(YankyPutIndentAfterLinewise)",
      },
      {
        "[P",
        "<Plug>(YankyPutIndentBeforeLinewise)",
      },
      {
        ">p",
        "<Plug>(YankyPutIndentAfterShiftRight)",
      },
      {
        "<p",
        "<Plug>(YankyPutIndentAfterShiftLeft)",
      },
      {
        ">P",
        "<Plug>(YankyPutIndentBeforeShiftRight)",
      },
      {
        "<P",
        "<Plug>(YankyPutIndentBeforeShiftLeft)",
      },
      {
        "=p",
        "<Plug>(YankyPutAfterFilter)",
      },
      {
        "=P",
        "<Plug>(YankyPutBeforeFilter)",
      },
      {
        "iy",
        function()
          require("yanky.textobj").last_put()
        end,
        mode = { "o", "x" },
      },
      {
        "[y",
        "<Plug>(YankyPreviousEntry)",
      },
      {
        "]y",
        "<Plug>(YankyNextEntry)",
      },
    },
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = function()
      vim.cmd([=[
        let g:undotree_WindowLayout = 3
        let g:undotree_SetFocusWhenToggle = 1
        let g:undotree_SplitWidth = 80
      ]=])
      vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>")
    end,
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

      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
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
  },

  {
    "ThePrimeagen/refactoring.nvim",
    lazy = false,
    dependencies = {
      "lewis6991/async.nvim",
    },
    opts = {},
    keys = {
      { "gR", function()
        require("refactoring").select_refactor()
      end, mode = { "n", "x" }, desc = "Refactor" },
    },
  },

  {
    "danymat/neogen",
    cmd = "Neogen",
    opts = {},
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
      end)
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

          map({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<CR>")

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
      vim.keymap.set("n", "<c-w>g", "<cmd>Gitsigns blame_line<CR>")
      vim.keymap.set("n", "<c-w><c-g>", "<cmd>Gitsigns blame_line<CR>")
      vim.keymap.set("n", "<leader>gh", function()
        vim.cmd("Gitsigns blame")
        vim.defer_fn(function()
          vim.cmd("wincmd w")
        end, 200)
      end, { silent = true, })
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
