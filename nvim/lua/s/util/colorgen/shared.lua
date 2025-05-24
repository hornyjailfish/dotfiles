local luv = require("s.util.colorgen.hsluv")
local util = require("s.util.colorgen")

local M ={}
local shared = {
  h = 1,
  s = 2,
  l = 3,
  hex = function(t)
    return tostring(t)
  end,
  lch = function(t)
    return luv.hsluv_to_lch(t)
  end,
  rgb = function(t)
    return luv.hsluv_to_rgb(t)
  end,
  contrast = function(t)
    return {
      util.contrasts(t,1),
      util.contrasts(t,2),
      util.contrasts(t,3),
      util.contrasts(t,5),
      util.contrasts(t,6),
      util.contrasts(t,7),
      util.contrasts(t,10),
      util.contrasts(t,12),
      util.contrasts(t,15),
      util.contrasts(t),
    }
  end,
  ratio = function(t)
    return t
  end,
  -- ratios = setmetatable({},ratio),
  complement = function(t)
    return util.compl(t)
  end,
  gray = function(t)
    return util.gray(t)
  end,

  __index = function(t, k)
    if type(k) == "number" then
      if k < 1 or k > 3 then
        return nil
      end
      return t[k] or nil
    end
    local m = getmetatable(t)
    if m[k] ~= nil then
      if type(m[k]) == "function" then
        return m[k](t)
      end
      return t[m[k]]
    end
    print("call",k)
    vim.notify("try to index nil key: ".. k,vim.log.levels.ERROR)
    return nil
  end,
  __newindex = function(t, k, v)
    print("new")
    return rawset(t, k, v)
  end,
  __call = function(t, ...)
    local args = { ... }
    if vim.tbl_isempty(args) then
      return tostring(t)
    else
      if type(args[1]) == "string" then
        return setmetatable(luv.hex_to_hsluv(args[1]), getmetatable(t))
      end
      if #args > 1 then
        return util.ratio(...)
      end
      return t
    end
  end,
  __tostring = function(t)
    return luv.hsluv_to_hex(t)
  end,
  __eq = function(t1, t2)
    return util.ratio(t1, t2) < 2
  end,

}

--- @param input string | table
function M.parse(input)
  local valid = true
  if type(input) == "string" then
    valid, input = pcall(luv.hex_to_hsluv, input)
  end
  if type(input) ~= "table" then
    valid = false
    return
  end
  if valid then
    return setmetatable(input, shared)
  end
  return nil
end

return M
