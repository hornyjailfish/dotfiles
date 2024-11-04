local wezterm = require("wezterm")

local M = {}
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(M, {
		label = "PowerShell prevew",
		args = { "pwsh.exe", "-NoLogo" },
	})

	-- -- Find installed visual studio version(s) and add their compilation
	-- -- environment command prompts to the menu
	-- for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
	-- 	local year = vsvers:gsub("Microsoft Visual Studio/", "")
	-- 	table.insert(M, {
	-- 		label = "x64 Native Tools VS " .. year,
	-- 		args = {
	-- 			"cmd.exe",
	-- 			"/k",
	-- 			"C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
	-- 		},
	-- 	})
	-- end
end

table.insert(M, {
	label = "Open WEZTERM CONFIG",
	args = { "nvim", wezterm.config_file },
	cwd = wezterm.config_dir,
})

return M
