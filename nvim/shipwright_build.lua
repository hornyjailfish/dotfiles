-- This is file for generationg werterm colorscheme from colo palette use <cmd>Shipwrighit to generate extra/wezterm.toml
local path = vim.fs.normalize(vim.fn.stdpath("config") .. "/extra/wezterm.toml")

--- FIXME: palette colornames different one to another so it need name tweaks for every palette. Run it in AU?
local util = require("util.shipwright_utils").palette

run(
	util,
	-- @param colors {
	--   fg = "#000000",
	--   bg = "#000000",
	--   cursor_fg = "#000000",
	--   cursor_bg = "#000000",
	--   cursor_border = "#000000",
	--   selection_fg = "#000000",
	--   selection_bg = "#000000",
	--   black = "#000000",
	--   red = "#000000",
	-- green = "#000000",
	--   yellow = "#000000",
	--   blue = "#000000",
	--   magenta = "#000000",
	--   cyan = "#000000",
	--   white = "#000000",
	--   bright_black = "#000000",
	--   bright_red = "#000000",
	--   bright_green = "#000000",
	--   bright_yellow = "#000000",
	--   bright_blue = "#000000",
	--   bright_magenta = "#000000",
	--   bright_cyan = "#000000",
	--   bright_white = "#000000",
	-- }
	function(colors)
		-- vim.inspect(colors)
		-- vim.inspect(util)
		return colors
		-- util.get_colors(colors)
		-- for _, key in ipairs(check_keys) do
		--   assert(colors[key],
		--     "wezterm colors table missing key: " .. key)
		-- end
		-- return {
		-- 	fg = colors.fg,
		-- 	bg = colors.bg,
		-- 	cursor_fg = colors.none,
		-- 	cursor_bg = colors.dark3,
		-- 	-- cursor_bg = colors.terminal_black ,
		-- 	cursor_border = colors.border_highlight,
		-- 	selection_fg = colors.none,
		-- 	selection_bg = colors.bg_visual,
		-- 	black = colors.black,
		-- 	red = colors.red,
		-- 	green = colors.green,
		-- 	yellow = colors.yellow,
		-- 	blue = colors.blue,
		-- 	magenta = colors.magenta,
		-- 	cyan = colors.cyan,
		-- 	white = colors.fg,
		-- 	bright_black = colors.dark3,
		-- 	bright_red = colors.red1,
		-- 	bright_green = colors.green2,
		-- 	bright_yellow = colors.orange,
		-- 	bright_blue = colors.blue1,
		-- 	bright_magenta = colors.magenta,
		-- 	bright_cyan = colors.cyan,
		-- 	bright_white = colors.yellow,
		-- }
	end,
	contrib.wezterm,
	{ overwrite, path }
)
