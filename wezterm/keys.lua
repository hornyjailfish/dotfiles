local wezterm = require("wezterm")
local M = {}

M = {
	{ key = "/", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "p",
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			-- Here you can dynamically construct a longer list if needed

			local home = wezterm.home_dir
			local proj = wezterm.GLOBAL.projects_dir
			local workspaces = {
				{ id = home,            label = "Home" },
				{ id = proj, label = "Projects" },
			}
			-- add all the workspaces in the projects directory
			for i, v in ipairs(wezterm.glob(proj .. "*")) do
				local dir = wezterm.truncate_left(v,
					v:len() - (proj:len()))
				table.insert(workspaces, {
					label = dir,
					id = v,
				})
			end

			window:perform_action(
				wezterm.action.InputSelector({
					action = wezterm.action_callback(function(inner_window, inner_pane, id,
										  label)
						if not id and not label then
							-- wezterm.log_info("Workspace selector cancelled")
							return
						else
							inner_window:perform_action(
								wezterm.action.SwitchToWorkspace({
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
		action = wezterm.action.PromptInputLine({
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
