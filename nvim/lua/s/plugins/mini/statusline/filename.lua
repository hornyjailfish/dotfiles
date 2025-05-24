local M = {}

local custom_filename = function(modified)
	local fn = "%f%r"
	if vim.bo.modified then
		local modified = require("s.util.hl").statusline("Bold")
		return
			{ hl = modified, strings = { fn } }
	else
		return
			{ hl = "MiniStatuslineFilename", strings = { fn } }
	end
end


local modified_buf_icon = function(modified)
	local m = ""
	--
	if vim.bo.modified then
		m = "[]"
	else
		m = ""
	end
	return { hl = modified, strings = { m } }
end

M.status = function()
	local name = custom_filename()

	return MiniStatusline.combine_groups({name})
end


return M
