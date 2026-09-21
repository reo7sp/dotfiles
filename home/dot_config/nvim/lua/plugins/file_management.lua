return {

  {
    "bogado/file-line",
  },

  {
    "pbrisbin/vim-mkdir",
  },

  {
    "awalland/nvim-file-watch",
    opts = {
      notify = false,
    },
  },

  {
    "farmergreg/vim-lastplace",
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
      ignoreUnsavedChangesBufs = false,
      deleteBufferWhenFileDeleted = true,
      deleteFunction = function(bufnr)
        if not require("barbar.state").is_pinned(bufnr) then
          vim.api.nvim_buf_delete(bufnr, {})
        end
      end,
      notificationOnAutoClose = true,
    },
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
    keys = {
      {
        "<leader>Zz",
        "<cmd>AutoSession search<cr>",
        desc = "Find sessions",
      },
      {
        "<leader>ZZ",
        "<cmd>AutoSession search<cr>",
        desc = "Find sessions",
      },
      {
        "<leader>Zw",
        "<cmd>AutoSession save<cr>",
        desc = "Save session",
      },
      {
        "<leader>ZW",
        "<cmd>AutoSession save<cr>",
        desc = "Save session",
      },
      {
        "<leader>Zd",
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
    config = function()
      require("workspaces").setup()

      local find_workspaces = function()
        require("telescope").extensions.workspaces.workspaces({
          layout_config = {
            width = 0.7,
            height = 0.5,
          },
        })
      end

      local delete_workspace = function()
        local actions = require("telescope.actions")
        require("telescope.pickers").new({}, {
          prompt_title = "Delete workspace",
          finder = require("telescope.finders").new_table({
            results = require("workspaces").get(),
            entry_maker = function(workspace)
              return {
                value = workspace,
                display = workspace.name .. "  " .. workspace.path,
                ordinal = workspace.name .. " " .. workspace.path,
              }
            end,
          }),
          sorter = require("telescope.config").values.generic_sorter({}),
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              local workspace = require("telescope.actions.state").get_selected_entry()
              actions.close(prompt_bufnr)
              if workspace then
                require("workspaces").remove(workspace.value.name)
              end
            end)
            return true
          end,
        }):find()
      end

      vim.keymap.set("n", "<leader>Mm", find_workspaces, { desc = "Find workspaces", })
      vim.keymap.set("n", "<leader>MM", find_workspaces, { desc = "Find workspaces", })
      vim.keymap.set("n", "<leader>Mw", "<cmd>WorkspacesAdd<cr>", { desc = "Add workspace", })
      vim.keymap.set("n", "<leader>MW", "<cmd>WorkspacesAdd<cr>", { desc = "Add workspace", })
      vim.keymap.set("n", "<leader>Md", delete_workspace, { desc = "Pick workspace to delete", })
      vim.keymap.set("n", "<leader>MD", delete_workspace, { desc = "Pick workspace to delete", })
    end,
  },

}
