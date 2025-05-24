local wezterm = require("wezterm")
local M = {}
M.palette = {
	foreground = "#B4BDC3",
	background = {
		light = "#cccccc",
		dark = "#333333",
	},
	cursor_fg = "#1C1917",
	cursor_bg = "#C4CACF",
	cursor_border = "#1C1917",
	selection_fg = "#B4BDC3",
	selection_bg = "#3D4042",
	muted = "#226EA8",
	active = "#A83632",
	inactive = "#2B3A45",
}

local colorscheme = "zenbones_"
-- should lower in this case
local appear = wezterm.gui.get_appearance():lower()
-- local colorscheme = "seoulbones_light"
local colors = wezterm.color.get_builtin_schemes()[colorscheme .. appear]
-- color_scheme_dirs = { "~/.dotfiles/nvim/extra/wezterm.toml"},
-- local shipwright_nvim_path = "c:/Users/5q/.dotfiles/nvim/extra/"
-- local colors, metadata = wezterm.color.load_scheme(shipwright_nvim_path .. "wezterm.toml")
-- wezterm.add_to_config_reload_watch_list(shipwright_nvim_path)



-- bg_color = colors.background,
local inactive_tab = {
	bg_color = M.palette.background[appear],
	fg_color = colors.ansi[8],
}

-- bg_color = colors.background,
local active_tab = {
	bg_color = M.palette.background[appear],
	fg_color = colors.brights[4],
}

M.custom_colors = {
	quick_select_label_fg = { Color = M.palette.cursor_fg },
	quick_select_label_bg = { Color = M.palette.muted },
}
M.tabs = {
	tab_bar = {
		-- background = colors.background,
		background = M.palette.background[appear],
		active_tab = active_tab,
		inactive_tab = inactive_tab,

		inactive_tab_hover = active_tab,
		new_tab = inactive_tab,
		new_tab_hover = active_tab,
		inactive_tab_edge = colors.ansi[5], -- (Fancy tab bar only)
	},
}
M.colors = colors
M.window_background_opacity = wezterm.GLOBAL.alpha or 1

-- M.win32_system_backdrop = 'Tabbed'
-- M.win32_system_backdrop = 'Mica'
M.win32_system_backdrop = 'Acrylic'

return M
