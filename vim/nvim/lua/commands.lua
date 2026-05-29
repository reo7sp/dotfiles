-- -----------------------------------------------------------------------------
-- yank file line reference
local function current_filename()
  local filename = vim.fn.expand("%")
  local cwd = vim.fn.getcwd() .. "/"
  if vim.startswith(filename, cwd) then
    return filename:sub(#cwd + 1)
  end
  return filename
end

vim.api.nvim_create_user_command("YankFilename", function()
  vim.fn.setreg("+", current_filename())
end, {})

vim.api.nvim_create_user_command("YankReference", function()
  vim.fn.setreg("+", current_filename() .. ":" .. vim.fn.line("."))
end, {})

vim.api.nvim_create_user_command("YankAbsFilename", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, {})

vim.api.nvim_create_user_command("YankAbsReference", function()
  vim.fn.setreg("+", vim.fn.expand("%:p") .. ":" .. vim.fn.line("."))
end, {})

vim.api.nvim_create_user_command("YankReferenceRange", function(opts)
  local line_start = math.min(opts.line1, opts.line2)
  local line_end = math.max(opts.line1, opts.line2)
  vim.fn.setreg("+", string.format("%s:%d-%d", current_filename(), line_start, line_end))
end, {
  range = true,
})

-- -----------------------------------------------------------------------------
-- gui editor integration
local function run_shell(args)
  local escaped_args = {}
  for _, arg in ipairs(args) do
    if arg ~= "" then
      table.insert(escaped_args, vim.fn.shellescape(arg))
    end
  end
  vim.cmd("!" .. table.concat(escaped_args, " "))
end

local function project_dir_for_vscode_editor()
  local dir = vim.fn.getcwd()
  local homedir = (vim.uv or vim.loop).os_homedir()
  if dir == homedir then
    return ""
  end
  return dir
end

vim.api.nvim_create_user_command("Subl", function(opts)
  if opts.fargs[1] == "dir" then
    run_shell({ "subl", vim.fn.getcwd() })
  else
    run_shell({ "subl", vim.fn.expand("%:p") .. ":" .. vim.fn.line(".") })
  end
end, {
  desc = "Open in Sublime Text",
  nargs = "?",
  complete = function()
    return { "dir" }
  end,
})

vim.api.nvim_create_user_command("Smerge", function(opts)
  if opts.fargs[1] == "blame" then
    run_shell({ "smerge", "blame", vim.fn.expand("%:p") })
  elseif opts.fargs[1] == "log" then
    run_shell({ "smerge", "log", vim.fn.expand("%:p") })
  else
    run_shell({ "smerge", vim.fn.getcwd() })
  end
end, {
  desc = "Open in Sublime Merge",
  nargs = "?",
  complete = function()
    return { "dir", "blame", "log" }
  end,
})

vim.api.nvim_create_user_command("Code", function(opts)
  if opts.fargs[1] == "dir" then
    run_shell({ "code", vim.fn.getcwd() })
  else
    run_shell({ "code", project_dir_for_vscode_editor(), "-g", vim.fn.expand("%:p") .. ":" .. vim.fn.line(".") })
  end
end, {
  desc = "Open in VS Code",
  nargs = "?",
  complete = function()
    return { "dir" }
  end,
})

vim.api.nvim_create_user_command("Cursor", function(opts)
  if opts.fargs[1] == "dir" then
    run_shell({ "cursor", vim.fn.getcwd() })
  else
    run_shell({ "cursor", project_dir_for_vscode_editor(), "-g", vim.fn.expand("%:p") .. ":" .. vim.fn.line(".") })
  end
end, {
  desc = "Open in Cursor",
  nargs = "?",
  complete = function()
    return { "dir" }
  end,
})

require("commands.custom")
