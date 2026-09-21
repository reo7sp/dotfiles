local plugins = {}
vim.list_extend(plugins, require("plugins.general"))
vim.list_extend(plugins, require("plugins.editor"))
vim.list_extend(plugins, require("plugins.appearance"))
vim.list_extend(plugins, require("plugins.file_management"))
vim.list_extend(plugins, require("plugins.navigation"))
vim.list_extend(plugins, require("plugins.languages"))
vim.list_extend(plugins, require("plugins.commands"))
if vim.env.NVIM_SKIP_CUSTOM_PLUGINS ~= "1" then
  vim.list_extend(plugins, require("plugins.custom"))
end

return plugins
