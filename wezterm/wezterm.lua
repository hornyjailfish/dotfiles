local wezterm = require("wezterm")
local act = wezterm.action

-- function for merging tables together
local function merge(...)
	local result <const> = {}
	-- For each source table
	for _, t in ipairs({ ... }) do
		-- For each pair in t
		for k, v in pairs(t) do
			result[k] = v
		end
	end
	return result
end

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

wezterm.on("gui-startup", function()
	local tab, pane, window = wezterm.mux.spawn_window({})
	window:gui_window():maximize()
end)
local launch_menu = {}
-- table.insert(launch_menu,{
-- 	label = "Let's ROCK",
-- 	args = wezterm.mux.spawn_window { workspace =  'coding'  },
-- })

wezterm.on("m_load_workspace", function(name)
	wezterm.mux.spawn_window({ workspace = name })
end)

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(launch_menu, {
		label = "PowerShell prevew",
		args = { "pwsh.exe", "-NoLogo" },
	})

	-- -- Find installed visual studio version(s) and add their compilation
	-- -- environment command prompts to the menu
	-- for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
	-- 	local year = vsvers:gsub("Microsoft Visual Studio/", "")
	-- 	table.insert(launch_menu, {
	-- 		label = "x64 Native Tools VS " .. year,
	-- 		args = {
	-- 			"cmd.exe",
	-- 			"/k",
	-- 			"C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
	-- 		},
	-- 	})
	-- end
end

-- table.insert(launch_menu, {
-- 	label = "Open WEZTERM config",
-- 	args = { "nvim", "wezterm.lua" },
-- 	cwd = "~/.config/wezterm/",
-- })
table.insert(launch_menu, {
	label = "Open WEZTERM CONFIG",
	args = { "nvim", wezterm.config_file },
	cwd = wezterm.config_dir,
})

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
-- local success, stdout, stderr = wezterm.run_child_process { 'wezterm', 'cli','list','--format','json' }
-- local list
-- if success==true then
-- 	list = wezterm.json_parse(stdout)
-- end

-- local colorscheme = "Gruvbox Material (Gogh)"
-- local colorscheme = "zenbones_dark"
local colorscheme = "neobones_light"
-- local colorscheme = "neobones_dark"
-- local colorscheme = "seoulbones_light"
local colors = wezterm.color.get_builtin_schemes()[colorscheme]
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
local custom_colors = {
	quick_select_label_fg = { Color = palette.cursor_fg },
	quick_select_label_bg = { Color = palette.muted },
}
local tabs = {
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
-- scheme = table.pack(tabs, colors)

-- print(scheme)
-- scheme = table.pack(scheme, tabs)
-- for index, value in ipairs(scheme) do
--   table.unpack(value)
-- end
config = {

	quick_select_alphabet = "colemak",
	colors = merge(colors, tabs, custom_colors),
	-- color_scheme_dirs = { "~/.dotfiles/nvim/extra/wezterm.toml"},
	-- window_background_opacity = 1,
	-- color_scheme = "wezterm.toml",

	-- color_scheme = "Catppuccin Latte",
	-- color_scheme = "zenbones_dark",
	-- color_scheme = colorscheme,

	font = wezterm.font("IosevkaTerm NFM"),
	-- font = wezterm.font("MesloLGL Nerd Font Mono"),
	-- font = wezterm.font("M+1Code Nerd Font"),
	-- font = wezterm.font("0xProto Nerd Font"),
	-- font = wezterm.font("CommitMono Nerd Font"),
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

	default_prog = { "nu", "-l" },
	keys = {
		{ key = "/", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
		{
			key = "p",
			mods = "ALT",
			action = wezterm.action_callback(function(window, pane)
				-- Here you can dynamically construct a longer list if needed

				local home = wezterm.home_dir
				local git_path = "/gits/"
				local workspaces = {
					{ id = home, label = "Home" },
					{ id = home .. "/gits", label = "/gits" },
				}
				for i, v in ipairs(wezterm.glob(home .. git_path .. "*")) do
					local dir = wezterm.truncate_left(v, v:len() - (wezterm.home_dir:len() + git_path:len()))
					table.insert(workspaces, {
						label = dir,
						id = v,
					})
				end

				window:perform_action(
					act.InputSelector({
						action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
							if not id and not label then
								wezterm.log_info("cancelled")
							else
								wezterm.log_info("id = " .. id)
								wezterm.log_info("label = " .. label)
								inner_window:perform_action(
									act.SwitchToWorkspace({
										name = label,
										spawn = {
											label = "Workspace: " .. label,
											cwd = id,
										},
									}),
									inner_pane
								)
							end
						end),
						title = "Choose Workspace",
						choices = workspaces,
						fuzzy = true,
						-- fuzzy_description = "Fuzzy find and/or make a workspace",
					}),
					pane
				)
			end),
		},
		{
			key = "N",
			mods = "CTRL|SHIFT",
			action = act.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { AnsiColor = "Fuchsia" } },
					{ Text = "Enter name for new workspace" },
				}),
				action = wezterm.action_callback(function(window, pane, line)
					-- line will be `nil` if they hit escape without entering anything
					-- An empty string if they just hit enter
					-- Or the actual line of text they wrote
					if line then
						window:perform_action(
							act.SwitchToWorkspace({
								name = line,
							}),
							pane
						)
					end
				end),
			}),
		},
	},
	launch_menu = launch_menu,
}
-- unix_domains = {
-- 	{
-- 		name = "prog",
-- 	},
-- },
config.default_mux_server_domain = "local"
-- config.unix_domains = {
-- 	name = "wezterm",
-- 	socket_path = "~/wezterm.sock",
-- 	no_serve_automaticly = true,
-- }

return config
