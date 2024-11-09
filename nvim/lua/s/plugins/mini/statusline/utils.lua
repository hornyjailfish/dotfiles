---statusline utilities
local M = {}

-- List of filetypes that use custom statusline
M.blocked_filetypes = {
	["neo-tree"] = true,
	["ministarter"] = true,
	["undotree"] = true,
	["diff"] = true,
	["OverseerList"] = true,
	["trouble"] = true,
	["DiffviewFiles"] = true,
}

M.get_icon = function(filetype,fallback)
	filetype = filetype or vim.bo.filetype
	local icon, color = M.devicons.get_icon("", vim.bo.filetype)
	-- print (vim.inspect(M.devicons),icon,color)
	if color == nil then
		icon, color = M.icons.get("filetype", vim.bo.filetype)
	end
	if color == nil then
		fallback = fallback or "MiniStatuslineFilename"
		color = fallback
	end
	-- print (icon,color)
	return icon, color
end

-- removing empty tables before combine it
-- just in case
M.remove_empty_tables = function(t)
	local i = 1
	while i <= #t do
		if type(t[i]) == "table" and next(t[i]) == nil then
			table.remove(t, i)
		else
			i = i + 1
		end
	end
end
--- init icons?
M.init = function()
	if require("s.util").has("mini.icons") then
		M.icons = require("mini.icons")
	else
		local opts = require("s.util").opts("mini.icons")
		M.icons = require("mini.icons")
		M.icons.setup(opts)
	end

	if require("s.util").has("nvim-web-devicons") then
		M.devicons = require("nvim-web-devicons")
	else
		local opts = require("s.util").opts("nvim-web-devicons")
		M.devicons = require("nvim-web-devicons")
		M.devicons.setup(opts)
	end

	-- ---load devicons not sure do i need setup here?
	-- local opts = require("s.util").opts("nvim-web-devicons")
	-- M.devicons = require("nvim-web-devicons")
	-- M.devicons.setup(opts)
end

return M
