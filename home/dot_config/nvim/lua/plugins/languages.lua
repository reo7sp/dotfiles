return {

  {
    "sheerun/vim-polyglot",
    init = function()
      vim.g.polyglot_disabled = { "sensible", "autoindent" }
      vim.g.no_plugin_maps = 1
      vim.g.vim_markdown_no_default_key_mappings = 1
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })
      vim.opt.runtimepath:prepend(require("lazy.core.config").plugins["nvim-treesitter"].dir .. "/runtime")

      local langs = {
        "c",
        "cpp",
        "cmake",
        "go",
        "python",
        "perl",
        "ruby",
        "lua",
        "rust",
        "bash",
        "make",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "jinja",
        "sql",
        "json",
        "yaml",
        "toml",
        "xml",
        "proto",
        "dockerfile",
        "vim",
        "markdown",
        "diff",
        "gitcommit",
        "git_rebase",
      }
      require("nvim-treesitter").install(langs)

      local langs_map = {}
      for _, lang in ipairs(langs) do
        langs_map[lang] = true
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local filetype = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(filetype) or filetype

          if not langs_map[lang] then
            return
          end

          local max_filesize = 1000 * 1024
          local name = vim.api.nvim_buf_get_name(args.buf)
          local ok, stats = pcall(vim.uv.fs_stat, name)
          if ok and stats and stats.size > max_filesize then
            return
          end

          local highlights = vim.treesitter.query.get(lang, "highlights")
          if not highlights then
            return
          end

          vim.treesitter.start(args.buf)
        end,
      })
    end,
    lazy = false,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      move = {
        set_jumps = true,
      },
    },
    keys = {
      {
        "cm",
        function()
          require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
        end,
        desc = "Swap parameter with next",
      },
      {
        "]f",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@call.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next function call start",
      },
      {
        "]m",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next method/function def start",
      },
      {
        "]c",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next class start",
      },
      {
        "]i",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next conditional start",
      },
      {
        "]l",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start("@loop.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next loop start",
      },
      {
        "]F",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@call.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next function call end",
      },
      {
        "]M",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next method/function def end",
      },
      {
        "]C",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next class end",
      },
      {
        "]I",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@conditional.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next conditional end",
      },
      {
        "]L",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_end("@loop.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Next loop end",
      },
      {
        "[f",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@call.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev function call start",
      },
      {
        "[m",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev method/function def start",
      },
      {
        "[c",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev class start",
      },
      {
        "[i",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev conditional start",
      },
      {
        "[l",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start("@loop.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev loop start",
      },
      {
        "[F",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@call.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev function call end",
      },
      {
        "[M",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev method/function def end",
      },
      {
        "[C",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev class end",
      },
      {
        "[I",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@conditional.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev conditional end",
      },
      {
        "[L",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_end("@loop.outer", "textobjects")
        end,
        mode = { "n", "x", "o" },
        desc = "Prev loop end",
      },
    },
  },

  {
    "catgoose/nvim-colorizer.lua",
    main = "colorizer",
    opts = {
      options = {
        parsers = {
          names = {
            enable = false,
          },
        },
        display = {
          mode = "virtualtext",
        },
      },
    },
    event = "BufReadPre",
  },

  {
    "reo7sp/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    init = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "go.mod",
        callback = function(args)
          vim.bo[args.buf].filetype = "gomod"
        end,
      })
    end,
    opts = {
      lsp_keymaps = false,
      lsp_codelens = false,
      lsp_document_formatting = false,
      lsp_inlay_hints = {
        enable = false,
      },
      textobjects = false,
      diagnostic = false,
      dap_debug = false,
      dap_debug_keymap = false,
      dap_debug_vt = false,
      lsp_gofumpt = false,
      luasnip = false,
      tag_options = "",
      comment_placeholder = "",
    },
    ft = "go",
  },

  {
    "Vimjas/vim-python-pep8-indent",
    ft = "python",
  },

  {
    "HiPhish/jinja.vim",
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
        end,
      })
    end,
    opts = {
      preset = "obsidian",
      completions = {
        lsp = {
          enabled = true,
        },
      },
      max_file_size = 1,
      heading = {
        sign = false,
        position = "inline",
        width = "block",
      },
      code = {
        sign = false,
        conceal_delimiters = false,
        language = false,
        border = "thin",
        width = "block",
      },
      file_types = {
        "markdown",
        "codecompanion",
      },
    },
    ft = {
      "markdown",
      "codecompanion",
    },
  },

  {
    "hat0uma/csvview.nvim",
    opts = {
      view = {
        display_mode = "border",
      },
      keymaps = {
        textobject_field_inner = {
          "if",
          mode = { "o", "x" },
        },
        textobject_field_outer = {
          "af",
          mode = { "o", "x" },
        },
        jump_next_field_end = {
          "<Tab>",
          mode = { "n", "v" },
        },
        jump_prev_field_end = {
          "<S-Tab>",
          mode = { "n", "v" },
        },
        jump_next_row = {
          "<Enter>",
          mode = { "n", "v" },
        },
        jump_prev_row = {
          "<S-Enter>",
          mode = { "n", "v" },
        },
      },
    },
    ft = {
      "csv",
      "tsv",
    },
  },

  {
    "rodjek/vim-puppet",
    init = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.pp",
        callback = function(args)
          vim.bo[args.buf].filetype = "puppet"
        end,
      })
    end,
    ft = "puppet",
  },

  {
    "vmware-archive/salt-vim",
    init = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.sls",
        callback = function(args)
          vim.bo[args.buf].filetype = "sls"
        end,
      })
    end,
    ft = "sls",
  },

  {
    "fladson/vim-kitty",
    init = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "kitty.conf",
        callback = function(args)
          vim.bo[args.buf].filetype = "kitty"
        end,
      })
    end,
    ft = "kitty",
  },

}
