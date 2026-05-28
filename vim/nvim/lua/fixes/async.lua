local promise_async = dofile(vim.fn.stdpath("data") .. "/lazy/promise-async/lua/async.lua")
local structured_async = require("async.nvim")

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
