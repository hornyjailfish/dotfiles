local M = {}

local codeium_loaded = function()
	if require("s.util").has("Codeium") or vim.fn.exists("g:loaded_codeium") ~= 0 then
		return vim.fn["codeium#Enabled"]()
	else
		return false
	end
end

-- this if chain so ugly damn
local codeium = function()
	if codeium_loaded() then
		if vim.api.nvim_get_mode() ~= "^[iR]" then
			return "", "MiniStatuslineFileinfo"
		end

		if vim.b._codeium_status == 1 then
			return " ", "MiniStatuslineModeOther"
		end
		local text = vim.trim(vim.fn["codeium#GetStatusString"]())
		if text == '0' then
			return " " .. text, "MiniStatuslineFileinfo"
		end
		return " " .. text, "MiniStatuslineModeInsert"
	else
		return "󱏏", "MiniStatuslineFileinfo"
	end
end


M.status = function()
	local text, hl = codeium()
	return { hl = hl, strings = { text } }
end

return M
