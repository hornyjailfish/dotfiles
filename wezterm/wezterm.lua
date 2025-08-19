--- @type Wezterm
local wezterm = require("wezterm")

local config = wezterm.config_builder or {}

wezterm.GLOBAL.alpha = 1
-- dir for InputSelector fuzzyfind
-- projects_dir = (wezterm.home_dir .. "/gits/")
wezterm.GLOBAL.projects_dir = (wezterm.home_dir:gsub("\\", "/") .. "/gits/")

require("./event_handlers")
local util = require("./utils")
local hotkeys = require("./keys")
local launch_menu = require("./launch_menu")
local color_config = require("./colors")
local plugins = require("./plugins")






local keys = util.tbl_merge(plugins.keys, hotkeys)
config = {
	automatically_reload_config = true,
	use_dead_keys = false,
	allow_win32_input_mode = true,
	keys = keys,
	quick_select_alphabet = "qwerty",

	display_pixel_geometry = "BGR",
	max_fps = 144,
	enable_wayland = false,
	webgpu_power_preference = "HighPerformance",
	front_end = 'OpenGL',

	colors = util.tbl_merge(color_config.colors, color_config.tabs, color_config.custom_colors),
	-- window_decorations = "NONE",
	window_background_opacity = color_config.window_background_opacity,
	win32_system_backdrop = color_config.win32_system_backdrop,
	integrated_title_buttons = { 'Close' },
	-- font = wezterm.font("ZedMono NF"),
	font = wezterm.font("IosevkaTerm NFM"),
	-- font = wezterm.font("EnvyCodeR Nerd Font Mono"),
	-- font = wezterm.font("MD IO Medium"),
	-- font = wezterm.font("MesloLGS Nerd Font Mono"),

	font_size = 14.0,
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

	prefer_to_spawn_tabs = true,
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
	launch_menu = launch_menu,
	default_prog = { "nu" },
	-- default_domain = "localhost",
	default_workspace = wezterm.mux.get_active_workspace(),
	unix_domains = {
		{
			name = "localhost",
			-- serve_command = { "nu", "-l" },
			-- socket_path = "~/.local/wezterm/sock",
			skip_permissions_check = true,
		},
	},
	-- default_gui_startup_args = { "start", "--domain", "localhost", "--attach", "--", "nu", "-l" },
	-- default_mux_server_domain = "localhost",
}

-- need upd before loading
-- util.set_gpu(config)

return config
