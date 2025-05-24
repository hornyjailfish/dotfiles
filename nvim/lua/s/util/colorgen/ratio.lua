local util  = require "s.util.colorgen"
local ratios = {
  __index = function(t, k)
    if type(k) == "number" then
      if k < 1 or k > 22 then
        return nil
      end
      return setmetatable(util.contrasts(shared, k) or {}, {})
    end
    local m = getmetatable(t)
    if m[k] ~= nil then
      if type(m[k]) == "function" then
        return m[k](t)
      end
      return t[m[k]]
    end
    vim.notify("try to index nil key: " .. k, vim.log.levels.ERROR)
    return nil
  end,
}

return ratios
