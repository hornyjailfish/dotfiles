local M = {}

local util = require("s.util.colorgen.util")
local hsluv = require("s.util.colorgen.hsluv")

local coty = "#FFBE98"

local function norm_angle(angle)
	local normalized = angle % 360.0
	if normalized < 0 then
		normalized = normalized + 360
		norm_angle(normalized)
	end
	return normalized
end

local function convert_copy(color)
	if type(color) == "string" then
		color = hsluv.hex_to_hsluv(color)
	end
	return vim.deepcopy(color)
end
-- +180
M.compl = function(color)
	local c = convert_copy(color)
	c[1] = norm_angle(c[1] + math.deg(math.pi))
	return c
end

-- +30 -30
M.analog = function(color)
	local c1 = convert_copy(color)
	local c2 = convert_copy(color)
	c1[1] = norm_angle(c1[1] + math.deg(math.pi / 6))
	c2[1] = norm_angle(c2[1] + math.deg(11 * math.pi / 6))
	return c1, c2
end

-- +120 +240
M.triadic = function(color)
	local c1 = convert_copy(color)
	local c2 = convert_copy(color)
	c1[1] = norm_angle(c1[1] + math.deg(2 * math.pi / 3))
	c2[1] = norm_angle(c2[1] + math.deg(4 * math.pi / 3))
	return c1, c2
end

-- +150 +210
M.splitcomp = function(color)
	local c1 = convert_copy(color)
	local c2 = convert_copy(color)
	c1[1] = norm_angle(c1[1] + math.deg(5 * math.pi / 6))
	c2[1] = norm_angle(c2[1] + math.deg(7 * math.pi / 6))
	return c1, c2
end

M.inv_l = function(color)
	local c = convert_copy(color)
	c[3] = 100 - c[3]
	return c
end

M.desat = function(color,delta)
	local delta = delta or 1
	if delta == 0 then
		vim.notify("ratio cannot be 0")
		return
	end

	local c = convert_copy(color)
	if c[3] > 50 then
		c[3] = c[3]-delta
	else
		c[3] = c[3]+delta
	end
	return c
end

M.gray = function(color)
	local c = convert_copy(color)
	c[2] = 0
	return c
end

M.ratio = function(color1, color2)
	local color1 = convert_copy(color1 or vim.g.base_color)
	local color2 = convert_copy(color2 or vim.g.base_color)
	return (math.max(color1[3], color2[3]) + 0.05) / (math.min(color1[3], color2[3]) + 0.05)
end

M.lum = function(color)
	local c = convert_copy(color)
	local lum = 0
	if c[3] < 50 then
		lum = c[3] * (c[2] / 100) * 2
	else
		lum = c[3] * (1 - (c[2] / 100)) * 2
	end
	return lum
end

local function invert_sat(color)
	local c = convert_copy(color)
	if c[2] >= 50 then
		c[2] = c[2] - 50
	else
		c[2] = c[2] + 50
	end
	return c
end

M.contrasts = function(color,ratio)
	local c = convert_copy(color)
	local light = vim.deepcopy(c)
	local dark = vim.deepcopy(c)
	local lum = c[3]
	local target = ((lum+0.05)/ratio)-0.05
	dark[3] = target
	dark = invert_sat(dark)
	light[3] = 100-target
	light = invert_sat(light)
	return light,dark
end

--- main color is vim.g.base_color if nil
M.cmp_contrasts = function(main,color1,color2)
	main = convert_copy(main or vim.g.base_color)
	color1 = convert_copy(color1)
	color2 = convert_copy(color2)
	if M.ratio(main, color1)>=M.ratio(main, color2) then
		return color1
	else
		return color2
	end

end

return M
