local M = {}

M.macro_status = function(color)
	if require("s.util").has("NeoComposer.nvim") then
		local mode_hl = require("s.util").hl.get(color)
		local config = require("s.util").opts("NeoComposer.nvim") or {}

		local state = require("NeoComposer.state")

		-- local _,c = require("nvim-web-devicons").get_icon_color_by_filetype(vim.bo.filetype)
		if vim.tbl_isempty(config) then
			config = { colors = {} }
			config.colors.red = require("s.util").hl.get("RecordingSymbol").fg
			config.colors.green = require("s.util").hl.get("PlayingSymbol").fg
			config.colors.fg = require("s.util").hl.get(color).fg
			config.colors.bg = require("s.util").hl.get(color).bg
		end
		vim.api.nvim_set_hl(0, "RecordingSymbol", { bg = config.colors.fg, fg = config.colors.red })
		vim.api.nvim_set_hl(0, "PlayingSymbol", { bg = config.colors.fg, fg = config.colors.green })
		vim.api.nvim_set_hl(0, "RecordingText", { bg = config.colors.fg, fg = config.colors.bg })
		vim.api.nvim_set_hl(0, "PlayingText", { bg = config.colors.fg, fg = config.colors.bg })
	end
end

local function macro_icon()
	local state = require("NeoComposer.state")
	local delay_enabled = state.get_delay()
	if state.get_recording() then
		return { hl = "RecordingSymbol", strings = { "" } }
	elseif state.get_playing() then
		return { hl = "PlayingSymbol", strings = { "" } }
	else
		return ""
	end
end

local function macro_text()
	local state = require("NeoComposer.state")
	local delay_enabled = state.get_delay()
	if state.get_recording() then
		return { hl = "RecordingText", strings = { "REC" } }
	elseif state.get_playing() then
		return { hl = "PlayingText", strings = { "PLAY" } }
	else
		return ""
	end
end

M.icon = function()
	return macro_icon()
end
M.text = function()
	return macro_text()
end

return M
