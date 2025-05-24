local M = {}

---util for create custom hl for statusline diagnostic match bg
local utils = require("s.plugins.mini.statusline.utils")
M.diagnostic_status = function()
	local status = utils.statuslineHL
	local error = require("s.util").hl.get("DiagnosticSignError")
	local warn = require("s.util").hl.get("DiagnosticSignWarn")
	local info = require("s.util").hl.get("DiagnosticSignInfo")
	local hint = require("s.util").hl.get("DiagnosticSignHint")
	vim.api.nvim_set_hl(0, "DiagnosticStatusError", { bg = status.bg, fg = error.fg })
	vim.api.nvim_set_hl(0, "DiagnosticStatusWarn", { bg = status.bg, fg = warn.fg })
	vim.api.nvim_set_hl(0, "DiagnosticStatusInfo", { bg = status.bg, fg = info.fg })
	vim.api.nvim_set_hl(0, "DiagnosticStatusHint", { bg = status.bg, fg = hint.fg })
end
-- shows lsp-status or devicon if filetype is supported
local lsp_loading_status = function(icon)
	-- if vim.lsp.buf.server_ready() then

	if #require("lsp-status").status_progress() == 0 then
		local name, _ = require("s.util.hl").clone("MiniStatuslineFilename", nil,
			{ bg = utils.statuslineHL.bg or "none", fg = vim.g.ft_color, reverse = false })
		return icon, name
	else
		return require("lsp-status").status_progress(), "MiniStatuslineDevInfo"
	end
end


M.status = function()
	local text, hl = lsp_loading_status(vim.g.ft_icon)
	return { hl = hl, strings = { text or "" } }
end

M.errors = function()
	local text = require("lsp-status").status_errors()
	return { hl = "DiagnosticStatusError", strings = { text or "" } }
end

M.warnings = function()
	local text = require("lsp-status").status_warnings()
	return { hl = "DiagnosticStatusWarn", strings = { text or "" } }
end

M.infos = function()
	local text = require("lsp-status").status_info()
	return { hl = "DiagnosticStatusInfo", strings = { text or "" } }
end

M.hints = function()
	local text = require("lsp-status").status_hints()
	return { hl = "DiagnosticStatusHint", strings = { text or "" } }
end

return M
