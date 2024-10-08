local icons = require("mini.icons")
icons.setup()
---------Utilities
local isnt_normal_buffer = function()
	-- For more information see ":h buftype"
	return vim.bo.buftype ~= ""
end

local blocked_filetypes = {
	["neo-tree"] = true,
	["starter"] = true,
	["undotree"] = false,
	["diff"] = true,
	["OverseerList"] = true,
	["Trouble"] = false,
}
-- local function remove_empty_tables(t)
-- 	local i = 1
-- 	while i <= #t do
-- 		if type(t[i]) == "table" and next(t[i]) == nil then
-- 			table.remove(t, i)
-- 		else
-- 			i = i + 1
-- 		end
-- 	end
-- end

local codeium_loaded = function()
	if package.loaded["Codeium"] or vim.fn.exists("g:loaded_codeium") ~= 0 then
		local text = vim.fn["codeium#GetStatusString"]()
		if text == "off" then
			return false
		end
		return true
	else
		return false
	end
end

local codeium = function()
	if codeium_loaded() then
		local text = vim.trim(vim.fn["codeium#GetStatusString"]())
		if text == "ON" then
			return "", "MiniStatuslineFileinfo"
		elseif text == "OFF" then
			return "", "StatusLine"
		end
		return " " .. text, "@keyword.return"
	else
		return "", "Comment"
	end
end
-- local kbd = require("config.socket")
-- kbd:connect()
-- print(vim.ispect(kbd.result))

---SADGE reverse not working with link
local create_copy_hl = function()
	local set_default_hl = function(name, data)
		data.default = true
		vim.api.nvim_set_hl(0, name, data)
	end
	set_default_hl("MiniStatuslineModeNormalAlt", { link = "Normal" })
	set_default_hl("MiniStatuslineModeInsertAlt", { link = "diffChanged" })
	set_default_hl("MiniStatuslineModeVisualAlt", { link = "diffAdded" })
	set_default_hl("MiniStatuslineModeReplaceAlt", { link = "diffRemoved" })
	set_default_hl("MiniStatuslineModeCommandAlt", { link = "diffNewFile" })
	set_default_hl("MiniStatuslineModeOtherAlt", { link = "diffFile" })
end

-- Mode -----------------------------------------------------------------------
-- Custom `^V` and `^S` symbols to make this file appropriate for copy-paste
-- (otherwise those symbols are not displayed).
local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)
-- stylua: ignore start
local modes = setmetatable({
  ['n']    = {  hl = 'MiniStatuslineModeNormalAlt' },
  ['v']    = {  hl = 'MiniStatuslineModeVisualAlt' },
  ['V']    = { hl = 'MiniStatuslineModeVisualAlt' },
  [CTRL_V] = { hl = 'MiniStatuslineModeVisualAlt' },
  ['s']    = { hl = 'MiniStatuslineModeVisualAlt' },
  ['S']    = { hl = 'MiniStatuslineModeVisualAlt' },
  [CTRL_S] = { hl = 'MiniStatuslineModeVisualAlt' },
  ['i']    = { hl = 'MiniStatuslineModeInsertAlt' },
  ['R']    = { hl = 'MiniStatuslineModeReplaceAlt' },
  ['c']    = { hl = 'MiniStatuslineModeCommandAlt' },
  ['r']    = { hl = 'MiniStatuslineModeOtherAlt' },
  ['!']    = { hl = 'MiniStatuslineModeOtherAlt' },
  ['t']    = { hl = 'MiniStatuslineModeOtherAlt' },
}, {
  -- By default return 'Unknown' but this shouldn't be needed
  __index = function()
    return   {  hl = '%#MiniStatuslineModeOther#' }
  end,
})
-- stylua: ignore end
--
local alt_mode_hl = function()
	local mode_info = modes[vim.fn.mode()]
	return mode_info.hl
end

local lsp_loading_status = function()
	-- local dev_bg = vim.api.nvim_get_hl(0, { name = "MiniStatuslineDevInfo" })
	local names = {}
	local icon, color = icons.get("filetype",vim.bo.filetype)
	color = require("s.util").get_hl(color)
	-- if vim.lsp.buf.server_ready() then
	if #require("lsp-status").status_progress() == 0 then
		for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			table.insert(names, server.name)
		end
		vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = color.fg })
		-- vim.api.nvim_set_hl(0, "MiniStatuslineDevInfo", { fg = color, bg = dev_bg.bg })
		return icon, "MiniStatuslineFileinfo"
		-- return "[" .. table.concat(names, " ") .. "]", "MoreMsg"
	else
		return require("lsp-status").status_progress(), "Comment"
		-- return "", "Comment"
	end
end

local pinned_bufer = function()
	if package.loaded["hbac"] ~= nil then
		local cur_buf = vim.api.nvim_get_current_buf()
		return require("hbac.state").is_pinned(cur_buf) and "" or ""
	end
	return ""
end

local graple_tag = function()
	if require("grapple").exists() then
		local key = require("grapple").name_or_index()
		-- return key
		return key .. " "
		-- return " [" .. key .. "]"
	end
	return ""
end

local function create_line()
	if blocked_filetypes[vim.bo.filetype] then
		return ""
	end
	-- vim.cmd("redrawstatus")
	local line = {}
	-- if isnt_normal_buffer() then
	-- 	local filename = section_filename({ trunc_width = 100 })
	-- 	line = {
	-- 		{ hl = "MiniStatuslineFileinfo", strings = { filename } },
	-- 	}
	-- else
	local err, macro = pcall(require, "NeoComposer.ui")
	if err then
		macro = macro.status_recording()
	end
	local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 9999 })
	local mode_hl_inv = alt_mode_hl()
	local git = MiniStatusline.section_git({ trunc_width = 75 })
	-- local diagnostics = MiniStatusline.section_diagnostics({ use_icons = false, trunc_width = 75 })
	local filename = MiniStatusline.section_filename({ trunc_width = 2000 })
	local location = MiniStatusline.section_location({ trunc_width = 99999 })
	local icon, color = icons.get("filetype",vim.bo.filetype)
	color = require("s.util").get_hl(color)
	local lsp, lsp_status = lsp_loading_status()
	local codeium_status, codeium_hl = codeium()
	line = {
		-- "%<", -- Mark general truncate point
		{ hl = mode_hl, strings = { graple_tag() } },
		{ hl = "MiniStatuslineDevInfo", strings = { macro, git } },
		"%<", -- Mark general truncate point
		{ hl = "MiniStatuslineFileinfo", strings = { filename } },
		-- { hl = "@field", strings = { filename } },
		"%=", -- End left alignment

		{ hl = "DiagnosticSignError", strings = { require("lsp-status").status_errors() } },
		{ hl = "DiagnosticWarn", strings = { require("lsp-status").status_warnings() } },
		{ hl = "DiagnosticInfo", strings = { require("lsp-status").status_info() } },
		{ hl = "DiagnosticHint", strings = { require("lsp-status").status_hints() } },
		{ hl = lsp_status, strings = { lsp } },
		-- { hl = "MiniStatuslineFileinfo", strings = { icon } },
		{ hl = codeium_hl, strings = { codeium_status } },
		{ hl = mode_hl, strings = { location } },
	}
	vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = color.fg, reverse = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineModeNormalAlt", { fg = color.fg, reverse = false })
	-- end
	-- vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { bg = mode_hl.bg, fg = color })
	-- vim.api.nvim_set_hl(0, "MiniStatuslineFilenameInverted", { fg = color, reverse = true })
	-- vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { reverse = true, link = mode_hl })
	-- vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { reverse = true })
	-- remove_empty_tables(line)
	return MiniStatusline.combine_groups(line)
end

-- inactive line creation
local function inactive_line()
	-- vim.cmd("redrawstatus")
	local filename = MiniStatusline.section_filename({ trunc_width = 2000 })
	return MiniStatusline.combine_groups({
		{ hl = "Comment", strings = { filename } },
	})
end

return {
	{
		"echasnovski/mini.statusline",
		version = false,
		lazy = false,
		priority=8888,
		dependencies = {
			"echasnovski/mini.icons",
			-- "nvim-web-devicons",
		},
		config = function()
			create_copy_hl()
			require("mini.statusline").setup({
				content = {
					active = create_line,
					inactive = inactive_line,
				},
				use_icons = true,
			})
			-- vim.cmd("redrawstatus")
		end,
	},
}
