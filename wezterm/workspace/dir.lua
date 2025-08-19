local M = {}

---@type Wezterm
local wezterm = require("wezterm")

function M.esc(str)
	local out = str:gsub("\\", "/")
	return out
end

M.default_args = { "nu" }

-- local function make_list(full_path, list)
-- 	local out = {}
-- 	for _, p, _ in ipairs(list) do
-- 		local short = wezterm.truncate_left(M.esc(p), M.esc(p):len() - M.esc(full_path):len()-1) -- INFO: -1 because trailing slash added
-- 		table.insert(out, { path = p, dirname = short })
-- 	end
-- 	return out
-- end
--
local Project = {}
Project.__index = Project

Project.to_action = function(self, args)
	return { label = self.dirname, id = wezterm.json_encode({ path = self.name, args = self.args or args or M.default_args }) }
end

function Project:new()
end

function Project.from_string(str)
	local out = wezterm.json_parse(str)
	out.__index = Project
	return out
end

function Project:make_action(args)
	args = args or M.default_args
	self.args = args
	return {
		label = self.dirname,
		id = self:to_string()
	}
end

local function make_list(full_path, command)
	command = command or {
		"nu", "-c", "ls " ..
	full_path ..
	" | where type == 'dir' | sort-by modified | reverse | each { |$item| merge { dirname: ($item.name | path parse | get stem)} } | move dirname --after name | to json"
	}
	local success, stdout, stderr = wezterm.run_child_process(command)
	-- print("out:", success, stdout, stderr)
	if not success then
		wezterm.log_error("Failed to run command: " .. command .. " " .. stderr)
		return
	end
	local out = wezterm.json_parse(stdout)
	for _, p in ipairs(out) do
		p.__index = Project
		p.to_action = Project.to_action
	end
	return out
end


local ImportantPath = {}

function ImportantPath.to_action(path)
	return {
		label = path.label or path.path,
		id = wezterm.json_encode({
			path = path.path,
			args = path.args or
				M.default_args
		})
	}
end

ImportantPath.__index = ImportantPath
function ImportantPath:new()
	local mt = {
		__index = self,
		__call = function(this, ...)
			local out = {}
			for _, p in ipairs(this) do
				table.insert(out,this.to_action(p))
			end
			return out
		end
	}
	return setmetatable({}, mt)
end

function ImportantPath:add(path, label)
	table.insert(self, { path = path, label = label or path })
	return self
end

function ImportantPath:single(path, label) -- INFO: will be skipped on fetching nest projects
	table.insert(self, { single = true, path = path, label = label or path })
	return self
end


function ImportantPath:make_actions(args) -- args for nested projects
	-- INFO: format is { label = str_to_display, id = optional_string }
	local out = {}
	for _, p in ipairs(self) do
		table.insert(out, self.to_action(p))
	end
	local projects = self:project_list()
	for _, d in ipairs(projects) do
		for _, p in ipairs(d.list) do
			table.insert(out, p:to_action(args))
		end
	end
	return out
end

function ImportantPath:project_list()
	local out = {}
	out.__index = Project
	for _, p in ipairs(self) do
		if (not p.single) then
			table.insert(out, {
				dir = p.path,
				list = make_list(p.path)
			})
		end
	end
	return out
end

local Prog = {}
function Prog:default(cwd)
	return { dir = cwd, args = { "nu" } }
end

function Prog:set(cwd, args)
	return { dir = cwd, args = args }
end

function Prog:json()
	return wezterm.json_encode(self)
end

M.home = wezterm.home_dir:gsub("\\", "/")
M.workspaces = ImportantPath

return M
