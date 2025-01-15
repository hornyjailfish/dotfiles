local wezterm = require("wezterm")

local util = require("./utils")
local keys = require("./keys")
local launch_menu = require("./launch_menu")
local color_config = require("./colors")
local handlers = require("./event_handlers")



local config = wezterm.config_builder or {}

wezterm.GLOBAL.alpha = 0.3
-- dir for InputSelector fuzzyfind
wezterm.GLOBAL.projects_dir = (wezterm.home_dir .. "/gits/")


config = {
	automatically_reload_config = true,
	default_workspace = "Home",
	keys = keys,
	quick_select_alphabet = "colemak",

	display_pixel_geometry = "BGR",

	enable_wayland=false,
	webgpu_power_preference = "HighPerformance",
	front_end = 'OpenGL',

	colors = util.tbl_merge(color_config.colors, color_config.tabs, color_config.custom_colors),
	window_decorations = "NONE",
	window_background_opacity = color_config.window_background_opacity,
	win32_system_backdrop = color_config.win32_system_backdrop,
	integrated_title_buttons = { 'Close' },
	font = wezterm.font("IosevkaTerm NFM"),

	font_size = 14.0,
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

	hide_tab_bar_if_only_one_tab = false,
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,

	audible_bell = "SystemBeep",
	window_padding = {
		left = "0cell",
		right = "0cell",
		top = "0cell",
		bottom = "0cell",
	},

	default_mux_server_domain = "local",
	default_prog = { "nu", "-l" },
	launch_menu = launch_menu,
}

-- need upd before loading
util.set_gpu(config)

return config
