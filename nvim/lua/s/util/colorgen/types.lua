local util = require("s.util.colorgen.util")
local luv = require("s.util.colorgen.hsluv")
local coty = "#FFBE98"
local hex = luv.hex_to_rgb(coty)
-- INFO: magic constant is diff between 180 and web colorwhells results

local hp = luv.rgb_to_hsluv(hex)
local comp = vim.deepcopy(hp)
comp[1] = math.abs((hp[1] + 180))
comp[2]=luv.max_safe_chroma_for_lh(comp[3]+0.05, comp[1])
print(vim.inspect(hp))
print(vim.inspect(comp))
print(vim.inspect(luv.hpluv_to_hex(hp)))

print(vim.inspect(luv.hsluv_to_hex(comp)))
