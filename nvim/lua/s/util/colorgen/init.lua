local M = {}

local util = require("s.util.colorgen.util")
local hsluv = require("s.util.colorgen.hsluv")

local coty = "#FFBE98"

local function norm_angle(angle)
    local normalized = angle % 360
    if normalized < 0 then
        normalized = normalized + 360
    end
    return normalized
end
-- +180
M.compl = function(color)
	local c = vim.tbl_extend('force',color,{})
	c[1] = norm_angle(c[1] + math.deg(math.pi))
	return c
end

-- +30 -30
M.analog = function(color)
	local c1 = vim.tbl_extend('force',color,{})
	local c2 = vim.tbl_extend('force',color,{})
	c1[1] = norm_angle(c1[1] + math.deg(math.pi / 6))
	c2[1] = norm_angle(c2[1] + math.deg(11*math.pi / 6))
	return c1, c2
end

-- +120 +240
M.triadic = function(color)
	local c1 = vim.tbl_extend('force',color,{})
	local c2 = vim.tbl_extend('force',color,{})
	c1[1] = norm_angle(c1[1] + math.deg(2 * math.pi / 3))
	c2[1] = norm_angle(c2[1] + math.deg(4 * math.pi / 3))
	return c1, c2
end

-- +150 +210
M.splitcomp = function(color)
	local c1 = vim.tbl_extend('force',color,{})
	local c2 = vim.tbl_extend('force',color,{})
	c1[1] = norm_angle(c1[1] + math.deg(5 * math.pi / 6))
	c2[1] = norm_angle(c2[1] + math.deg(7 * math.pi / 6))
	return c1, c2
end

M.h2hpluv = function(color)
	return hsluv.hex_to_hpluv(color)
end
M.hp2h = function(color)
	return hsluv.hpluv_to_hex(color)
end

complement = function(color)
	--- {hue,chroma,lightness}
	local hp     = M.h2hpluv(color)
	local compl  = M.compl(M.h2hpluv(color))
	local a1, a2 = M.analog(M.h2hpluv(color))
	return M.hp2h(hp),
		M.hp2h(compl),
		M.hp2h(a1),
		M.hp2h(a2)
	-- return (hp),
	-- 	(compl),
	-- 	(a1),
	-- 	(a2)
end


return M
