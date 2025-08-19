---@type Wezterm
local wezterm = require("wezterm")
local M = {}

local ws = require("workspace.init").ws

local home = wezterm.home_dir
local proj = wezterm.GLOBAL.projects_dir
local workspaces = ws:new():single(home, "Home"):add(proj, "Projects"):add(wezterm.home_dir .. "/.node-red/uibuilder",
	"uibuilder")
-- local workspaces = {
-- 	{ label = "Home",     id = wezterm.json_encode { dir = home } },
-- 	{ label = "Projects", id = wezterm.json_encode { dir = proj } },
-- }

local function create_dir_list(path, truncate)
	truncate = truncate or false
	local out = {}
	-- print("path:", path)
	for _, d in ipairs(wezterm.glob(path .. "*")) do
		if truncate then
			d = wezterm.truncate_left(d,
				d:len() - (proj:len()))
			-- print("dir:", dir)
			-- table.insert(out, d)
		end
		-- print("dir:", d)
		table.insert(out, d)
	end
	-- print("out:", out)
	return out
end

local function sort_dir_list_with(list, command)
	-- print("list:", list)
	list = wezterm.json_encode(list)
	-- print("after:", list)
	command = command or {
		"nu", "-c", list ..
	" | each {|$path| | path exists | if $in { ls -D $path }} | flatten | sort-by modified | get name | reverse | to json"
	}
	local success, stdout, stderr = wezterm.run_child_process(command)
	-- print("out:", success, stdout, stderr)
	if not success then
		wezterm.log_error("Failed to run command: " .. command .. " " .. stderr)
		return
	end
	return wezterm.json_parse(stdout)
end
M.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
M.keys = {
	{
		key = "O",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			--- @type UrlObject
			local cwd_uri = pane:get_current_working_dir()
			if cwd_uri then
				local path = cwd_uri.file_path
				if wezterm.target_triple == "x86_64-pc-windows-msvc" then
					path = string.gsub(path, "^/", "")
					path = string.gsub(path, "/", "\\")
				end
				print(path)
				wezterm.open_with(path, "explorer")
			else
				window:toast_notification("WezTerm", "Cannot get current working directory", nil, 3000)
			end
		end)
	},
	{ key = "/", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "p",
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			-- add all the workspaces in the projects directory
			-- for i, v in ipairs(wezterm.glob(wezterm.GLOBAL.projects_dir .. "*")) do
			-- 	local dir = wezterm.truncate_left(v,
			-- 		v:len() - (proj:len()))
			-- 	table.insert(workspaces, {
			-- 		label = dir,
			-- 		id = wezterm.json_encode { dir = v, args = { "nvim" } }
			-- 	})
			-- end
			local list = workspaces:make_actions({ "nu", "-c", "nvim" })
			local tst = workspaces
			print(list)
			window:perform_action(
				wezterm.action.InputSelector({
					choices = list,
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						if not label then
							wezterm.log_error("Workspace selector mailformed")
							return
						else
							id = wezterm.json_parse(id)
							local default_prog = inner_window:effective_config().default_prog
							inner_window:perform_action(
								wezterm.action.SwitchToWorkspace({
									name = label,
									spawn = {
										label = "Workspace: " .. label,
										args = id.args or default_prog, -- INFO: this could fail
										cwd = id.path,
									},
								}),
								inner_pane
							)
						end
					end),
					title = "Choose Workspace",
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
		action = wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if hit escape without entering anything
				-- An empty string if just hit enter
				-- Or the actual line of text wrote
				if line then
					window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
}

return M
