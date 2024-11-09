local M = {}

if jit.os ~= 'Windows' then
	vim.notify("This plugin is only for Windows", vim.lsp.log_levels.ERROR)
end

local winreg = require("winreg")

local path = [[HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]]
local sys_key = "SystemUsesLightTheme"
local app_key = "AppsUseLightTheme"
local type = 4

-- dont forget to close it after use
M.path = winreg.openkey(path)
vim.api.nvim_create_autocmd("VimLeave", {
	desc = "close winreg handle",
	nested = true,
	callback = function()
		M.path:close()
	end
})
local function toggle(input)
	if input == 0 then
		return 1
	end
	if input == 1 then
		return 0
	end
	-- fallback to dark theme
	return 0
end

local function set_themes(app_val, sys_val)
	M.path:setvalue(app_key, toggle(app_val))
	M.path:setvalue(sys_key, toggle(sys_val))
end

local function set_app_theme(app_val)
	M.path:setvalue(app_key, toggle(app_val))
end

local function get_themes()
	local app_val, _ = M.path:getvalue(app_key)
	local sys_val, _ = M.path:getvalue(sys_key)
	return app_val, sys_val
end

local function get_app_theme()
	local app_val, _ = M.path:getvalue(app_key)
	return app_val
end

local function get_theme_name()
	local app = get_app_theme()
	-- only app theme used for nvim
	return app == 0 and "dark" or "light"
end

--- just data to use
M.config = {
	path = path,
	current_theme = get_theme_name(),
}

M.toggle_all = function()
	set_themes(get_themes())
	M.config.current_theme = get_theme_name()
	M.sync()
end

--- togle windows global setting for app theme
M.toggle = function()
	set_app_theme(get_app_theme())
	M.config.current_theme = get_theme_name()
	M.sync()
end

--- sync windows theme and vim.g.background
M.sync = function()
	M.config.current_theme = get_theme_name()
	local g = vim.opt
	g.background = M.config.current_theme
	vim.opt = g
end

return M
