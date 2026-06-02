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
    "amitds1997/remote-nvim.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = {
      "RemoteStart",
      "RemoteStop",
      "RemoteInfo",
      "RemoteCleanup",
      "RemoteConfigDel",
      "RemoteLog",
    },
    opts = {},
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
        desc = "Restore session",
      },
      {
        "<leader>zw",
        "<cmd>AutoSession save<cr>",
        desc = "Save session",
      },
      {
        "<leader>zd",
        "<cmd>AutoSession delete<cr>",
        desc = "Delete session",
      },
      {
        "<leader>zD",
        "<cmd>AutoSession deletePicker<cr>",
        desc = "Pick session to delete",
      },
    },
  },

}
