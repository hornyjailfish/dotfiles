local M = {}

local custom_fn = function(modified)
	local fn = "%f%r"
	if vim.bo.modified then
		return
			{ hl = modified, strings = { fn } }
	else
		return
			{ hl = "MiniStatuslineFileinfo", strings = { fn } }
	end
end


local modified_buf = function(modified)
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
	local modified = require("s.util.hl").statusline("Changed")
	local name = custom_fn(modified)
	local icon = modified_buf(modified)

	return MiniStatusline.combine_groups({name,icon})
end


return M
