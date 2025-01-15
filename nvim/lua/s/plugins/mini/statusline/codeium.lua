local M = {}

local codeium_loaded = function()
	if require("s.util").has("Codeium") or vim.fn.exists("g:loaded_codeium") ~= 0 then
		local text = vim.fn["codeium#GetStatusString"]()
		if text == "off" then
			return false
		end
		return true
	else
		return false
	end
end

-- this if chain so ugly damn
local codeium = function()
	if codeium_loaded() then
		local text = vim.trim(vim.fn["codeium#GetStatusString"]())
		if text == "ON" then
			return "", "MiniStatuslineFileinfo"
		elseif text == "OFF" then
			return "", "MiniStatuslineFileinfo"
		end
		if text == "*" then
			return " ", "MiniStatuslineModeOther"
		end
		if text == '0' then
			return " " .. text, "MiniStatuslineFileinfo"
		end
		return " " .. text, "MiniStatuslineModeInsert"
	else
		return "", "Comment"
	end
end


M.status = function()
	local text, hl = codeium()
	return { hl = hl, strings = { text } }
end

return M
