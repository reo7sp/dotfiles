vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.sh.tmpl",
  callback = function(args)
    vim.bo[args.buf].filetype = "sh"
  end,
})
