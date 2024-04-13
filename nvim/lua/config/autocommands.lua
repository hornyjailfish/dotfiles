vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	pattern = { "*" },
	callback = function(e)
		local path = "config.custom_colors."
		path = path .. vim.g.colors_name
		local palette = {}
		local ok, highlights = pcall(require, path)
		if ok then
			-- INFO: file in config/custom_colors/%coloname% should return palette table for shipwright
			palette = highlights()
		else
			vim.notify("cant load user-defined highlights for " .. e.match, 3)
		end

		if pcall(require, "NeoComposer.nvim") then
			vim.cmd("Lazy reload NeoComposer.nvim")
		end
		-- try build theme for wezterm
		-- require("util.shipwright_utils").create_palette(palette)
		-- local shipfile = vim.fs.normalize(vim.fn.stdpath("config") .. "/shipwright_build.lua")
		-- require("shipwright").build(shipfile)
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "neo-tree", "diff", "spectre_panel", "obsidianbacklinks" },
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

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

-- trim whitespaces preWrite
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true }),
	pattern = "*",
	callback = function()
		MiniTrailspace.trim()
		MiniTrailspace.trim_last_lines()
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.java" },
	callback = function()
		vim.lsp.codelens.refresh()
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.js" },
	callback = function()
		vim.lsp.codelens.refresh()
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.ts" },
	callback = function()
		vim.lsp.codelens.refresh()
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.py" },
	callback = function()
		vim.lsp.codelens.refresh()
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.lua" },
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
