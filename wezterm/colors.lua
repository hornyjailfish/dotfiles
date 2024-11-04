local wezterm = require("wezterm")
local M = {}
local palette = {
	foreground = "#B4BDC3",
	background = "#1C1917",
	cursor_fg = "#1C1917",
	cursor_bg = "#C4CACF",
	cursor_border = "#1C1917",
	selection_fg = "#B4BDC3",
	selection_bg = "#3D4042",
	muted = "#226EA8",
	active = "#A83632",
	inactive = "#2B3A45",
}

local colorscheme = "neobones_"
-- should lower in this case
local appear = wezterm.gui.get_appearance():lower()
-- local colorscheme = "seoulbones_light"
local colors = wezterm.color.get_builtin_schemes()[colorscheme .. appear]
-- color_scheme_dirs = { "~/.dotfiles/nvim/extra/wezterm.toml"},
-- local shipwright_nvim_path = "c:/Users/5q/.dotfiles/nvim/extra/"
-- local colors, metadata = wezterm.color.load_scheme(shipwright_nvim_path .. "wezterm.toml")
-- wezterm.add_to_config_reload_watch_list(shipwright_nvim_path)


wezterm.on("update-status", function(window, pane)
	-- local date = wezterm.strftime '%H:%M:%S'
	window:set_left_status(wezterm.format({
		{
			Foreground = { Color = palette.muted },
		},
		{
			Text = window:active_workspace() .. " ",
		},
	}))
end)

local inactive_tab = {
	bg_color = colors.background,
	fg_color = colors.ansi[8],
}

local active_tab = {
	bg_color = colors.background,
	fg_color = colors.brights[4],
}

M.custom_colors = {
	quick_select_label_fg = { Color = palette.cursor_fg },
	quick_select_label_bg = { Color = palette.muted },
}
M.tabs = {
	tab_bar = {
		background = colors.background,
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
