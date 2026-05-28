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
        return require("fixes.async")
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
      icons = {
        syntax = {
          var = "",
          method = "",
          ["function"] = "",
          ["arrow_function"] = "",
          parameter = "",
          associated = "",
          namespace = "",
          type = "",
          field = "",
          interface = "",
          module = "",
          flag = "",
        },
      },
    },
  },

  {
    "tpope/vim-repeat",
  },

}
