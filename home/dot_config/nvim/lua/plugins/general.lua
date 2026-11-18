return {

  {
    "nvim-lua/plenary.nvim",
  },

  {
    "lewis6991/async.nvim",
    lazy = true,
  },

  {
    "kevinhwang91/promise-async",
    init = function()
      package.preload.async = function()
        return require("fixes.async")
      end
    end,
    lazy = true,
  },

  {
    "kkharji/sqlite.lua",
    lazy = true,
  },

  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },

  {
    "ray-x/guihua.lua",
    opts = {
      maps = {
        split = "<C-x>",
      },
    },
    lazy = true,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      color_icons = false,
      override_by_extension = {
        yaml = {
          icon = "",
          name = "Yaml",
        },
        yml = {
          icon = "",
          name = "Yml",
        },
      },
    },
  },

  {
    "tpope/vim-repeat",
  },

}
