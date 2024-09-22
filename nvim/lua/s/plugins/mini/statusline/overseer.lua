local M = {}

local util = require("s.util")

local symbols = {
	["CANCELED"] = " ",
	["FAILURE"] = "󰅚 ",
	["SUCCESS"] = "󰄴 ",
	["RUNNING"] = "󰑮 ",
}

local get_tasks = function()
	if util.has("overseer.nvim") then
		local tasks = require("overseer.task_list").list_tasks({ unique = true })
		if vim.tbl_isempty(tasks) then
			return {}
		end
		local tasks_by_status = require("overseer.util").tbl_group_by(tasks, "status")
		return tasks_by_status
	else
		return {}
	end
end

local function create_section(status)
	local tasks = get_tasks()
	if tasks == nil then
		return ""
	end
	if tasks[status] ~= nil then
		local text = string.format("%s%d", symbols[status], #tasks[status])
		local hl = util.hl.statusline(string.format("Overseer%s", status))
		return { hl = hl, strings = { text } }
	else
		return ""
	end
end

M.failure = function()
	return create_section("FAILURE")
end
M.success = function()
	return create_section("SUCCESS")
end
M.running = function()
	return create_section("RUNNING")
end
M.canceled = function()
	return create_section("CANCELED")
end
M.status = function()
	return M.failure(), M.success(), M.running(), M.canceled()
end

return M
