--- util module for EZ highlighting
local M = {}


--- Get hl group in format { fg = hex, bg = hex, ...styles }
--- used 0 ns by default
--- and Normal as falback
---@param n string
---@param fallback string?
M.get = function(n, fallback)
	fallback = fallback or "Normal"
	local hl = vim.api.nvim_get_hl(0, { name = n, link = false })
	if hl == nil then
		hl = vim.api.nvim_get_hl(0, { name = fallback, link = false })
		if hl == nil then
			error("no such hl group " .. n .. " or " .. fallback)
		end
	end

	-- if hl.link ~= nil then
	-- 	return M.get(hl.link, fallback)
	-- end

	if hl.fg then
		hl.fg = string.format("#%06x", hl.fg)
	end
	if hl.bg then
		hl.bg = string.format("#%06x", hl.bg)
	else
		hl.bg = "NONE"
	end

	-- INFO: not reverse?
	if hl.reverse then
		local tmp = hl.fg
		hl.fg = hl.bg
		hl.bg = tmp
	end
	return hl
end

--- util function to clone hl group (CAUTON: it creates new hl group)
--- @param name string name of the hl group to clone
--- @param postfix string | number | nil postfix for the new group if empty `Upd` is used
--- @param hl vim.api.keyset.highlight? properties to override
--- @return string, vim.api.keyset.hl_info?
M.clone = function(name, postfix, hl)
	postfix = postfix or "Upd"
	local new_name = name .. postfix
	local tbl = M.get(name)

	if hl ~= nil then
		for k, v in pairs(hl) do
			tbl[k] = v
		end
	end

	vim.api.nvim_set_hl(0, new_name, tbl)
	return new_name, tbl
end

M.statusline = function(name)
	local hi = M.get(name)
	local status = M.get("MiniStatusLinefileinfo", "StatusLine")
	local reverse = status.reverse or false
	return M.clone(name, "Status", { bg = status.bg, fg = hi.fg })
end

--- util function to link hl groups
--- @param name string name of the hl group
--- @param link string? name of the hl group to link to ("Normal" is fallback)
M.link = function(name, link)
	link = link or "Normal"
	local str = string.format("link %s %s", name, link)
	vim.cmd.hi({ args = { str }, bang = true }) -- +-=etc
end

M.update_highlights = function(hl_group, opts)
	opts = opts or {}
	local hl_info = M.get(hl_group, hl_group)
	if hl_info == nil then return end
	local updated_opts = vim.tbl_deep_extend("keep", opts, hl_info)
	vim.api.nvim_set_hl(0, hl_group, updated_opts)
end

M.hl2dual = function(name, key)
	key = key or "fg"
	if require("s.util").has("dualism") == false then
		vim.notify_once("dualism is not installed/found",vim.log.levels.WARN)
		return
	end

	local color = require("dualism.color").color
	if color == nil then
		vim.notify("NOPE")
		return
	end

	local val = M.get(name)[key]
	if val == nil or val == "NONE" then
		return
	end

	return color:new(val)
end

return M
