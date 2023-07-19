-- TODO: fix light and dark background inversion for some colors

local default = vim.api.nvim_get_hl(0, { name = "Normal" })
local dumb_color = { "#333333", "#aaaaa0" }
local find_hl = function(get)
	local result = vim.api.nvim_get_hl(0, { name = get })
	return result
end

local M = {}
M.palette = {}
local wezterm_keys = {
	"fg",
	"bg",
	"cursor_fg",
	"cursor_bg",
	"cursor_border",
	"selection_fg",
	"selection_bg",
	"black",
	"red",
	"green",
	"yellow",
	"blue",
	"magenta",
	"cyan",
	"white",
	"bright_black",
	"bright_red",
	"bright_green",
	"bright_yellow",
	"bright_blue",
	"bright_magenta",
	"bright_cyan",
	"bright_white",
}

-- create then assign because of recursion
local get_hl
get_hl = function(name)
	local color = find_hl(name)
	if color == nil then
		return default
	else
		if color.link ~= nil then
			get_hl(color.link)
		end

		if not (color.bg or color.fg) then
			return default
		end
		-- BUG: string.format cuts heading/trailing zeroes
		if color.bg then
			color.bg = string.format("#%06x", color.bg)
		else
			color.bg = default.bg
		end

		if color.fg then
			color.fg = string.format("#%06x", color.fg)
		else
			color.fg = default.fg
		end
		-- print(vim.inspect(color))
		return color
	end
end

-- FIXME: not every hl group here defined for all themes so it use dumb_color value or default one
local general_palette = function()
	local base = {
		fg = get_hl("@text").fg,
		bg = get_hl("Normal").bg,
		cursor_fg = get_hl("Cursor").fg,
		cursor_bg = get_hl("Cursor").bg,
		cursor_border = get_hl("CursorLine").bg,
		selection_fg = get_hl("Visual").fg, -- nil
		selection_bg = get_hl("Visual").bg,
		--- bottom one is controversial but i try LUL
		black = get_hl("Comment").fg,
		red = get_hl("DiagnosticVirtualTextError").bg,
		green = get_hl("DiagnosticVirtualTextHint").bg,
		yellow = get_hl("DiagnosticVirtualTextWarn").bg,
		blue = get_hl("Search").bg,
		magenta = get_hl("Statement").fg,
		cyan = get_hl("Label").fg,
		white = "#FFFFFF",
		bright_black = get_hl("CursorLine").bg,
		bright_red = get_hl("DiagnosticError").fg,
		bright_green = get_hl("@keyword").fg,
		bright_yellow = get_hl("DiagnosticWarn").fg,
		bright_blue = get_hl("IncSearch").bg,
		bright_magenta = get_hl("Identifier").fg,
		bright_cyan = get_hl("Type").fg,
		bright_white = "#FFFFFF",
	}

	-- print(vim.inspect(base))
	return base
end
function M.create_palette(colors, skip_bright)
	skip_bright = skip_bright and true
	-- print(skip_bright)
	if vim.o.background ~= "dark" then
		dumb_color = { "#aaaaa0", "#333333" }
	end

	default = vim.api.nvim_get_hl(0, { name = "Normal" })
	if default.bg then
		default.bg = string.format("#%06x", default.bg)
	else
		default.bg = dumb_color[1]
	end
	if default.fg then
		default.fg = string.format("#%06x", default.fg)
	else
		default.fg = dumb_color[2]
	end

	-- INFO: if some keys exists in colors table use them or use default settings (just some hi groups)
	for i, key in ipairs(wezterm_keys) do
		M.palette[key] = colors[key]
		if colors[key] == nil then
			M.palette[key] = general_palette()[key]
			if skip_bright then
				local _, ends = string.find(key, "bright_")
				if ends then
					local tst = string.sub(key, ends + 1)
					M.palette[key] = colors[tst]
					-- print(key, tst)
				else
					M.palette[key] = general_palette()[key]
				end
			end
			-- print(key, "NIL")
		end
	end
	-- print(vim.inspect(M.palette))
	return M.palette
end

return M
