local M = {}
local util = require("s.util")
function M.on_attach(client, buffer)
	local self = M.new(client, buffer)

	self:map("K", vim.lsp.buf.hover, { desc = "Hover", border = "none", has = "hover" })
	self:map("gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
	self:map("<c-k>", vim.lsp.buf.signature_help, { mode = "i", desc = "Signature Help", has = "signatureHelp" })
	self:map("]d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
	self:map("[d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
	self:map("]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
	self:map("[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
	self:map("]w", M.diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
	self:map("[w", M.diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })

	self:map("<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", mode = { "n", "v" }, has = "codeAction" })
	self:map("<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
	self:map("<leader>cl", "LspInfo", { desc = "Lsp Info" })
	local format = require("s.plugins.lsp.format").format

	self:map("<leader>cf", format, { desc = "Format Document", has = "documentFormatting" })
	self:map("<leader>cf", format, { desc = "Format Range", mode = "v", has = "documentRangeFormatting" })
	self:map("<leader>cr", M.rename, { expr = true, desc = "Rename", has = "rename" })
end

function M.new(client, buffer)
	return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
	return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
	opts = opts or {}
	if opts.has and not self:has(opts.has) then
		return
	end
	vim.keymap.set(
		opts.mode or "n",
		lhs,
		type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
		{ silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
	)
end

function M.rename()
	if pcall(require, "inc_rename") then
		return ":IncRename " .. vim.fn.expand("<cword>")
	else
		vim.lsp.buf.rename()
	end
end

function M.diagnostic_goto(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

return M
