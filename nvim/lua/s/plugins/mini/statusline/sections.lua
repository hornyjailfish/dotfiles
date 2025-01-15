local M = {}
-- local kbd = require("config.socket")
-- kbd:connect()
-- print(vim.ispect(kbd.result))

--- is buf pined by hbac?
local pinned_bufer = function()
	if package.loaded["hbac"] ~= nil then
		local cur_buf = vim.api.nvim_get_current_buf()
		return require("hbac.state").is_pinned(cur_buf) and "" or ""
	end
	return ""
end

--- is grapped?
local graple_tag = function()
	if require("grapple").exists() then
		local key = require("grapple").name_or_index()
		-- return key
		return key .. " "
		-- return " [" .. key .. "]"
	end
	return ""
end


M.active = function()
	local utils = require("s.plugins.mini.statusline.utils")
	local filename = require("s.plugins.mini.statusline.filename")
	local lspstatus = require("s.plugins.mini.statusline.lspstatus")
	-- local composer = require("s.plugins.mini.statusline.neocomposer")
	local codeium = require("s.plugins.mini.statusline.codeium")
	local overseer = require("s.plugins.mini.statusline.overseer")

	local icon, color = utils.devicons.get_icon("", vim.bo.filetype)
	if color == nil then
		icon, color = utils.icons.get("filetype", vim.bo.filetype)
	end
	local status = require("s.util.hl").get("StatusLine", "StatusLineNC")

	--- @see utils.blocked_filetypes
	if utils.blocked_filetypes[vim.bo.filetype] then
		local hl, _ = require("s.util.hl").clone(color, nil, { bg = status.bg })
		--- INFO: THIS IS STATUSLINE FOR ONE IN CUSTOM FILETYPES TABLE
		return MiniStatusline.combine_groups({
			{ hl = hl, strings = { icon } },
			"%<", -- Mark general truncate point
			"%=", -- End left alignment
			{ hl = hl, strings = { vim.bo.filetype } },
		})
	end

	local line = {}
	--define default sections
	local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 9999 })
	local git = MiniStatusline.section_git({ trunc_width = 75 })
	local diagnostics = MiniStatusline.section_diagnostics({ use_icons = false, trunc_width = 75 })
	-- local filename = MiniStatusline.section_filename({ trunc_width = 2000 })
	local location = MiniStatusline.section_location({ trunc_width = 99999 })
	local icon, color = utils.devicons.get_icon("", vim.bo.filetype)
	if color == nil then
		icon, color = utils.icons.get("filetype", vim.bo.filetype)
	end
	---upd hl groups
	-- composer.macro_status(color)
	lspstatus.diagnostic_status()
	line = {
		{ hl = mode_hl, strings = { mode } },
		{ hl = mode_hl, strings = { graple_tag(), pinned_bufer() } },
		-- composer.icon(),
		-- composer.text(),
		{ hl = "MiniStatuslineDevInfo", strings = { git } },
		overseer.failure(),
		overseer.canceled(),
		overseer.success(),
		overseer.running(),
		"%<", -- Mark general truncate point
		filename.status(),
		-- "%<", -- Mark general truncate point
		"%=", -- End left alignment
		lspstatus.errors(),
		lspstatus.warnings(),
		lspstatus.infos(),
		lspstatus.hints(),
		lspstatus.status(),
		codeium.status(),
		{ hl = mode_hl,                 strings = { location } },
	}

	--- INFO: this needed because some sections could return empty table
	utils.remove_empty_tables(line)
	return MiniStatusline.combine_groups(line)
end
-- inactive line creation
M.inactive = function()
	local utils = require("s.plugins.mini.statusline.utils")
	local icon, color = utils.get_icon()
	local status = require("s.util").hl.get("MiniStatuslineFilename","StatusLineNC")
	local filename = MiniStatusline.section_filename({ trunc_width = 2000 })
	if utils.blocked_filetypes[vim.bo.filetype] then
		filename = vim.bo.filetype
	end
	local hl, _ = require("s.util.hl").clone(color, nil, { bg = status.bg })

	return MiniStatusline.combine_groups({
		{ hl = hl,                       strings = { icon } },
		"%<", -- Mark general truncate point
		"%=", -- End left alignment
		{ hl = "MiniStatuslineFilename", strings = { filename } },
	})
end


return M
