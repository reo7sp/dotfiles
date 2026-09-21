local data_path = vim.fn.stdpath("data")
local original_package_path = package.path

package.path = table.concat({
  data_path .. "/lazy/promise-async/lua/?.lua",
  data_path .. "/lazy/promise-async/lua/?/init.lua",
  data_path .. "/lazy/async.nvim/lua/?.lua",
  data_path .. "/lazy/async.nvim/lua/?/init.lua",
  original_package_path,
}, ";")

local promise_async = dofile(data_path .. "/lazy/promise-async/lua/async.lua")
local structured_async = dofile(data_path .. "/lazy/async.nvim/lua/async.lua")

package.path = original_package_path

local mt = getmetatable(promise_async) or {}
local original_index = mt.__index

mt.__index = function(tbl, key)
  if type(original_index) == "function" then
    local value = original_index(tbl, key)
    if value ~= nil then
      return value
    end
  elseif type(original_index) == "table" and original_index[key] ~= nil then
    return original_index[key]
  end

  return structured_async[key]
end

return setmetatable(promise_async, mt)
