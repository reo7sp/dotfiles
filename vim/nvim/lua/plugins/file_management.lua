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
        desc = "Restore session",
      },
      {
        "<leader>Zz",
        "<cmd>AutoSession restore<cr>",
        desc = "Restore session",
      },
      {
        "<leader>zZ",
        "<cmd>AutoSession search<cr>",
        desc = "Find sessions",
      },
      {
        "<leader>ZZ",
        "<cmd>AutoSession search<cr>",
        desc = "Find sessions",
      },
      {
        "<leader>zw",
        "<cmd>AutoSession save<cr>",
        desc = "Save session",
      },
      {
        "<leader>Zw",
        "<cmd>AutoSession save<cr>",
        desc = "Save session",
      },
      {
        "<leader>zd",
        "<cmd>AutoSession delete<cr>",
        desc = "Delete session",
      },
      {
        "<leader>Zd",
        "<cmd>AutoSession delete<cr>",
        desc = "Delete session",
      },
      {
        "<leader>zD",
        "<cmd>AutoSession deletePicker<cr>",
        desc = "Pick session to delete",
      },
      {
        "<leader>ZD",
        "<cmd>AutoSession deletePicker<cr>",
        desc = "Pick session to delete",
      },
    },
  },

  {
    "natecraddock/workspaces.nvim",
    opts = {},
  },

}
