local wezterm = require("wezterm")
local util = require("./utils")
local colors = require("./colors")

local M = {}

-- WARN: this is not triggered with `wezterm connect`
wezterm.on("gui-startup", function(name)
	local tab, pane, window = wezterm.mux.spawn_window({})
	window:gui_window():maximize()
end)

wezterm.on("gui-attached", function(domain)
	local workspace = wezterm.mux.get_active_workspace()
	for _, window in ipairs(wezterm.mux.all_windows()) do
		window:gui_window():maximize()
	end
end)

wezterm.on("mux-startup", function(name)
end)

local function log_proc(proc, indent)
	indent = indent or ''
	wezterm.log_info(
		indent
		.. 'pid='
		.. proc.pid
		.. ', name='
		.. proc.name
		.. ', status='
		.. proc.status
	)
	wezterm.log_info(indent .. 'argv=' .. table.concat(proc.argv, ' '))
	wezterm.log_info(
		indent .. 'executable=' .. proc.executable .. ', cwd=' .. proc.cwd
	)
	for pid, child in pairs(proc.children) do
		log_proc(child, indent .. '  ')
	end
end

wezterm.on('mux-is-process-stateful', function(proc)
	log_proc(proc)

	-- Just use the default behavior
	return nil
end)

wezterm.on("update-status", function(window, pane)
	if pane == nil then return end
	local id = pane and pane:pane_id() or 0
	local domain = pane and pane:get_domain_name(id) or ""
	local workspace = window:active_workspace() or ""
	window:set_left_status(wezterm.format({
		{
			Foreground = { Color = colors.palette.muted },
		},
		{
			Text = workspace .. "@" .. domain .. " ",
		},
	}))

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
