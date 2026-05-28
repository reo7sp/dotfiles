return {

  {
    "bogado/file-line",
  },

  {
    "pbrisbin/vim-mkdir",
  },

  {
    "okuuva/auto-save.nvim",
    opts = {
      lockmarks = true,
      condition = function(buf)
        local filetype = vim.fn.getbufvar(buf, "&filetype")
        if vim.list_contains({ "oil", "qf" }, filetype) then
          return false
        end
        return true
      end
    },
  },

  {
    "farmergreg/vim-lastplace",
  },

  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        auto_create = false,
        auto_restore = false,
        git_use_branch_name = true,
      })
      vim.cmd([=[
        set sessionoptions+=winpos,terminal,folds
      ]=])
    end,
    lazy = false,
    keys = {
      {
        "<leader>zz",
        "<cmd>AutoSession restore<cr>",
      },
      {
        "<leader>zw",
        "<cmd>AutoSession save<cr>",
      },
      {
        "<leader>zd",
        "<cmd>AutoSession delete<cr>",
      },
      {
        "<leader>zD",
        "<cmd>AutoSession deletePicker<cr>",
      },
    },
  },

}
