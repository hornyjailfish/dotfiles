vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	pattern = { "*" },
	callback = function(e)
		local path = "config.custom_colors."
		path = path .. e.match
		local ok, highlights = pcall(require, path)
		if ok then
			highlights()
		else
			vim.notify("cant load user-defined highlights for " .. e.match, 3)
		end
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "obsidianbacklinks" },
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]])
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
-- 	callback = function()
-- 		vim.cmd("quit")
-- 	end,
-- })

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	callback = function()
		vim.cmd("set formatoptions-=cro")
	end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.java" },
	callback = function()
		vim.lsp.codelens.refresh()
	end,
})

--- now i use native kbd layouts
-- local kbd = require("config.socket")
-- vim.api.nvim_create_autocmd({ "InsertLeave" }, {
-- 	callback = function()
-- 		kbd.msg = "qwerty"
-- 	end,
-- })
-- vim.api.nvim_create_autocmd({ "InsertEnter" }, {
-- 	callback = function()
-- 		kbd.msg = "colemak"
-- 	end,
-- })
