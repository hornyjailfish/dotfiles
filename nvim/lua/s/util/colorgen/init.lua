local M = {}

local util = require("s.util.colorgen.util")
local hsluv = require("s.util.colorgen.hsluv")

local coty = "#FFBE98"

complement = function(color)
	--- {hue,chroma,lightness}
	local c = hsluv.hex_to_rgb(coty)
	print(vim.inspect(c))
	local comp = hsluv.hex_to_rgb(coty)
	local lch = hsluv.rgb_to_lch(comp)
	lch[3] = lch[3] + 180
	comp = hsluv.lch_to_rgb(lch)
	local hpuv = hsluv.rgb_to_hpluv(c)
	hpuv[3] = hpuv[3] + 180
	local compl = hsluv.hpluv_to_rgb(hpuv)
	-- print(vim.inspect(comp))
	-- comp[1] = comp[1] + math.deg(math.pi)
	-- comp[2] = hsluv.max_safe_chroma_for_lh(comp[3], comp[1])
	local conv = hsluv.hpluv_to_hex(c)
	local orig = hsluv.rgb_to_hex(comp)
	local out = hsluv.rgb_to_hex(compl)
	print(coty,conv,orig,out)
end
