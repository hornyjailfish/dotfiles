local M = {}
local luv = require("s.util.colorgen.hsluv")
local util = require("s.util.colorgen")

--- @class hsl.Color
--- @field 1 number hue
--- @range 0-360
--- @field 2 number saturation
--- @range 0-100
--- @field 3 number lightness

--- @type hsl.Color
local color = {
  32.8, 7.7, 81.7
}

local meta = require"s.util.colorgen.shared"

--- @type hsl.Color[]
local theme = {
  base = { 32.8, 7.7, 81.7 },
  bg = vim.g.bg_color,
  white = "#FFFFFF",
  black = "000000",
}

local ratios = {
  __index = function(t, k)
    if type(k) == "number" then
      if k < 1 or k > 22 then
        return nil
      end
      return setmetatable(util.contrasts(meta.shared,k) or {},meta.shared)
    end
    local m = getmetatable(t)
    if m[k] ~= nil then
      if type(m[k]) == "function" then
        return m[k](t)
      end
      return t[m[k]]
    end
    vim.notify("try to index nil key: ".. k,vim.log.levels.ERROR)
    return nil
  end,
}


function M.create_palette(palette)
  palette = palette or { bg = vim.g.bg_color, base = vim.g.base_color, ft = vim.g.ft_color }
  for k, v in pairs(palette) do
    palette[k] = meta.parse(v)
  end
 palette.ratio = function(t1,t2)
    return util.ratio(t1,t2)
  end
 palette.to_ratio = function(t,val)
    return util.contrasts(t,val or 7.5)
  end
  return palette
end

local p = M.create_palette()
-- print(vim.inspect(p.base.ratio))
print(vim.inspect(p.to_ratio(p.base,7).hex),p.base.hex)




return M
