local wezterm = require("wezterm")
local util = require("./utils")

local M = {}

wezterm.on("gui-startup", function()
	local tab, pane, window = wezterm.mux.spawn_window({})
	-- local override = window:get_config_overrides() or {}
	-- util.set_gpu(override)
	-- window:set_config_overrides(override)
	window:gui_window():maximize()
end)


wezterm.on("m_load_workspace", function(name)
	wezterm.mux.spawn_window({ workspace = name })
end)


wezterm.on("update-status", function(window, pane)
	local bat = ''
	local override = window:get_config_overrides() or {}
	for _, b in ipairs(require("wezterm").battery_info()) do
		if b.state == 'Discharging' then
			util.set_gpu(override)
			bat = '🔋 '
		else
			bat =
				(override.webgpu_preferred_adapter and override.webgpu_preferred_adapter.name)
				or ""
		end
	end
	window:set_right_status(wezterm.format {
		{ Text = bat .. '  ' },
	})
	window:set_config_overrides(override)
end)
