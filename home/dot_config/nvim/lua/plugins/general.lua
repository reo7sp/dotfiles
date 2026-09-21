return {

  {
    "nvim-lua/plenary.nvim",
  },

  {
    "lewis6991/async.nvim",
  },

  {
    "kevinhwang91/promise-async",
    init = function()
      package.preload.async = function()
        return require("fixes")
      end
    end,
  },

  {
    "kkharji/sqlite.lua",
  },

  {
    "MunifTanjim/nui.nvim",
  },

  {
    "ray-x/guihua.lua",
    opts = {
      maps = {
        split = "<C-x>",
      },
    },
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      color_icons = false,
    },
  },

  {
    "tpope/vim-repeat",
  },

}
