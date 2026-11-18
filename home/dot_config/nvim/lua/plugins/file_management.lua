return {

  {
    "lewis6991/fileline.nvim",
    cond = require("utils.if_no_kitty_scrollback"),
  },

  {
    "pbrisbin/vim-mkdir",
    cond = require("utils.if_no_kitty_scrollback"),
  },

  {
    "awalland/nvim-file-watch",
    opts = {
      notify = false,
    },
    cond = require("utils.if_no_kitty_scrollback"),
  },

  {
    "farmergreg/vim-lastplace",
    cond = require("utils.if_no_kitty_scrollback"),
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
    cond = require("utils.if_no_kitty_scrollback"),
  },

  {
    "chrisgrieser/nvim-early-retirement",
    dependencies = {
      "romgrk/barbar.nvim",
    },
    init = function()
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          local diffview_buffers = {}
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(bufnr)
                and vim.bo[bufnr].buftype == ""
                and vim.api.nvim_buf_get_name(bufnr):match("^diffview://") then
              vim.bo[bufnr].buftype = "nowrite"
              diffview_buffers[#diffview_buffers + 1] = bufnr
            end
          end

          vim.schedule(function()
            for _, bufnr in ipairs(diffview_buffers) do
              if vim.api.nvim_buf_is_valid(bufnr) then
                vim.bo[bufnr].buftype = ""
              end
            end
          end)
        end,
      })
    end,
    opts = {
      retirementAgeMins = 30,
      ignoreUnsavedChangesBufs = false,
      deleteBufferWhenFileDeleted = true,
      deleteFunction = function(bufnr)
        if not require("barbar.state").is_pinned(bufnr) then
          local filename = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
          vim.api.nvim_buf_delete(bufnr, {})
          vim.notify(("Auto-closed %q"):format(filename), vim.log.levels.INFO, { title = "early-retirement" })
        end
      end,
      notificationOnAutoClose = false,
    },
    cond = require("utils.if_no_kitty_scrollback"),
  },

  {
    "rmagatti/auto-session",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
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
    cond = require("utils.if_no_kitty_scrollback"),
    keys = {
      {
        "<leader>xx",
        "<Cmd>AutoSession search<CR>",
        desc = "Find sessions",
      },
      {
        "<leader>xw",
        "<Cmd>AutoSession save<CR>",
        desc = "Save session",
      },
      {
        "<leader>xd",
        "<Cmd>AutoSession deletePicker<CR>",
        desc = "Pick session to delete",
      },
    },
  },

}
