local augroup = vim.api.nvim_create_augroup("Custom", { clear = true })

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	pattern = { "*" },
	callback = function(e)
		local path = "s.config.custom_colors."
		-- local split_table = vim.gsplit(vim.g.colors_name,'-')
		path = path .. e.match
		-- local palette = {}
		local ok, highlights = pcall(require, path)
		require("s.util.theme").sync()
		require("s.util.theme")
		if ok then
			highlights()
		else
			vim.notify("cant load user-defined highlights for " .. e.match, 3)
		end
		local bg = require("s.util.hl").get("Normal")
		vim.cmd.redraw()
		if bg.bg == nil then
			return
		else
			vim.g.bg_color = bg.bg
		end

		-- try build theme for wezterm
		-- require("util.shipwright_utils").create_palette(palette)
		-- local shipfile = vim.fs.normalize(vim.fn.stdpath("config") .. "/shipwright_build.lua")
		-- require("shipwright").build(shipfile)
	end,
})
local cg = require("s.util.colorgen")
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = augroup,
	--filter?
	callback = function()
		-- check no init here
		require("s.plugins.mini.statusline.utils").init()
		local _, hl = require("s.plugins.mini.statusline.utils").devicons.get_icon_by_filetype(vim.bo.filetype)
		if hl == nil then
			_, hl = require("s.plugins.mini.statusline.utils").icons.get("filetype", vim.bo.filetype)
		end
		if hl == nil then
			return
		end
		local ft = require("s.util.hl").get(hl, "MiniStatusLineModeNormal")
		local ins = require("s.util.hl").get("MiniStatusLineModeNormal")
		local norm = require("s.util.hl").get("Normal")
		if ft.fg == nil or ins.bg == nil or norm.fg == nil then
			return
		end
		if cg.ratio(ft.fg, norm.fg) >= cg.ratio(ins.fg, ft.fg) then
			vim.api.nvim_set_hl(0, "MiniStatusLineModeNormal", { bg = ft.fg, fg = norm.fg })
		else
			vim.api.nvim_set_hl(0, "MiniStatusLineModeNormal", { bg = ft.fg, fg = ins.fg })
		end
	end
})

-- TODO: get patterns into utils.custom_ft table
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "neo-tree", "diff", "spectre_panel", "obsidianbacklinks", 'nofile' },
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
		-- if require("plugins.lsp.keymaps").has("codeLens") then
		-- vim.lsp.codelens.refresh()
		-- end
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.js" },
	callback = function()
		-- if require("plugins.lsp.keymaps").has("codeLens") then
		-- vim.lsp.codelens.refresh()
		-- end
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.ts" },
	callback = function()
		-- if require("plugins.lsp.keymaps").has("codeLens") then
		-- vim.lsp.codelens.refresh()
		-- end
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.py" },
	callback = function()
		-- if require("plugins.lsp.keymaps").has("codeLens") then
		vim.lsp.codelens.refresh()
		-- end
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.lua" },
	callback = function()
		-- if require("plugins.lsp.keymaps").has("codeLens") then
		vim.lsp.codelens.refresh()
		-- end
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
