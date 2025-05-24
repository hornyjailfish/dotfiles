local util = require("s.util.colorgen.util")
local luv = require("s.util.colorgen.hsluv")
local coty = "#FFBE98"
local rgb = luv.hex_to_rgb(coty)
-- INFO: magic constant is diff between 180 and web colorwhells results

local hs = luv.hex_to_hsluv(coty)
local hp = luv.hex_to_hpluv(coty)
local comp = vim.deepcopy(hs)
local tst = luv.luv_to_lch(comp)
tst[2] = luv.max_safe_chroma_for_lh(tst[1], tst[3])
vim.inspect(tst)
local out = luv.hpluv_to_hex(luv.lch_to_hpluv(tst))

print(vim.inspect(comp))
print(vim.inspect(tst))
print(vim.inspect(out))
