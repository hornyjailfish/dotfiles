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

M.desat = function(color, delta)
	local delta = delta or 1
	if delta == 0 then
		vim.notify("ratio cannot be 0")
		return
	end

	local c = convert_copy(color)
	if c[3] > 50 then
		c[2] = c[2] - delta
	else
		c[2] = c[2] + delta
	end
	return c
end

M.gray = function(color)
	local c = convert_copy(color)
	c[2] = 0
	return c
end

M.ratio = function(color1, color2)
	local L1 = M.lum(color1)
	local L2 = M.lum(color2)
	if color1 == nil or color2 == nil then return end
	return (math.max(L1, L2) + 0.05) / (math.min(L1, L2) + 0.05)
end

M.lum = function(color)
	local c = convert_copy(color)
	if c == nil then return end
	return hsluv.l_to_y(c[3])
end
M.lig = function(Y)
	local c = convert_copy(color)
	return hsluv.y_to_l(Y)
end

function M.invert_sat(color)
	local c = convert_copy(color)
	if c[2] >= 50 then
		c[2] = c[2] - 50
	else
		c[2] = c[2] + 50
	end
	return c
end

function M.compensate_lightness_with_saturation(color)
	local c = convert_copy(color)

	if c[3] < 0 then
		c[3] = 0
		c[2] = c[2] * (color[3] / 100)
	elseif c[3] > 100 then
		c[3] = 100
		c[2] = c[2] * ((100 - color[2]) / 100)
	end
	c[2] = math.max(0, math.min(100, c[2]))

	return c
end

local function calculate_target_luminance(L, CR)
	return (L + 0.05) / CR - 0.05, (L + 0.05) * CR - 0.05
end

M.contrasts = function(color, ratio)
	if ratio == nil or ratio <= 0 then
		vim.notify("invalid contrast ratio")
		ratio = nil
	end
	ratio = ratio or 7.5
	local bg = convert_copy(color)
	local L = M.lum(color)
	-- local combine = math.sqrt(math.pow(bg[1],2)+math.pow(bg[2],2))
	local chroma = (1 - math.abs(2 * L - 1)) * bg[2] / 100
	print("pre", chroma)
	local dark, light = calculate_target_luminance(L, ratio)
	-- local new_lightness = math.max(0, math.min(100, L2 * 100))
	local dark_l = M.lig(dark)
	local light_l = M.lig(light)
	-- local new_lightness = math.max(0,math.min(100,M.lig(L2)))
	if vim.opt.background:get() == "light" then
		bg[3] = light_l
	elseif vim.opt.background:get() == "dark" then
		bg[3] = dark_l
	end
	return M.compensate_lightness_with_saturation(bg)
end

--- main color is vim.g.base_color if nil
M.cmp_contrasts = function(main, color1, color2)
	main = convert_copy(main or vim.g.base_color)
	color1 = convert_copy(color1)
	color2 = convert_copy(color2)
	if M.ratio(main, color1) >= M.ratio(main, color2) then
		return color1
	else
		return color2
	end
end

return M
