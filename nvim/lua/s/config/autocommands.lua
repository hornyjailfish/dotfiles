local augroup = vim.api.nvim_create_augroup("Squirrel", { clear = true })

vim.api.nvim_create_autocmd({ "ColorSchemePre" }, {
	pattern = { "*" },
	group = augroup,
	callback = function(e)
		if vim.g.transparent_enabled then
			-- INFO: switch transparent off to get bg color
			-- its sets back on ColorScheme au
			-- (some colorschemes set this on caching stage so use palette from them instead)
			-- @look nvim/lua/s/config/custom_colors/tokyonight
			--
			-- it depends on transparent plugin!
			if require("s.util").has("transparent") then
				vim.cmd("TransparentToggle")
				vim.g.was_transparent = true
			else
				vim.notify("transparent plugin is not installed!", vim.log.levels.WARN)
			end
		else
			vim.g.was_transparent = false
		end
	end,
})
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	pattern = { "*" },
	callback = function(e)
		local path = "s.config.custom_colors."
		path = path .. e.match
		local ok, highlights = pcall(require, path)

		require("s.util.theme").sync()

		if ok then
			highlights()
		else
			vim.notify("cant load user highlights for " .. e.match, 3)
		end
		local bg = require("s.util.hl").get("Normal")
		if bg.bg == nil then
			return
		else
			vim.g.bg_color = bg.bg
		end
		if vim.g.was_transparent == true then
			if require("s.util").has("transparent") then
				vim.cmd("TransparentToggle")
			else
				vim.notify("transparent plugin is not installed!", vim.log.levels.WARN)
			end
		end
		require("s.plugins.mini.statusline.utils").statuslineHL = require("s.util.hl").get("StatusLine", "StatusLineNC")
		-- vim.cmd.redraw()
	end,
})

local cg = require("s.util.colorgen")

-- this is for setting MiniStatusLineModeNormal bg to current filetype from devicons
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = augroup,
	callback = function()
		-- check no init here
		require("s.plugins.mini.statusline.utils").init()
		local icon, hl = require("s.plugins.mini.statusline.utils").devicons.get_icon_by_filetype(vim.bo.filetype)
		if hl == nil then
			icon, hl = require("s.plugins.mini.statusline.utils").icons.get("filetype", vim.bo.filetype)
		end
		if hl == nil then
			return
		end

		local ft_mod = require("s.util.hl").hl2dual(hl,"fg")
		local norm = require("s.util.hl").hl2dual("Normal","bg")
		local norm_fg = require("s.util.hl").hl2dual("Normal","fg")
		if ft_mod == nil then
			return
		end
		vim.g.ft_color = ft_mod:hex()
		vim.g.ft_icon = icon
		if norm ~= nil then
			ft_mod = ft_mod:mix(norm,0.2)
		end
		vim.api.nvim_set_hl(0, "MiniStatusLineModeNormal", { bg = ft_mod:pastel():hex(), fg = norm_fg:tint(2):hex() })
	end
})

-- quit buffers with q
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
-- TODO: depends on mini so move out of here
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true }),
	pattern = "*",
	callback = function()
		MiniTrailspace.trim()
		MiniTrailspace.trim_last_lines()
	end,
})


--- now i use native kbd layouts
-- local kbd = require("s.config.socket")
-- vim.api.nvim_create_autocmd({ "InsertLeave" }, {
-- 	callback = function()
-- 		kbd.msg = "main"
-- 	end,
-- })
-- vim.api.nvim_create_autocmd({ "InsertEnter" }, {
-- 	callback = function()
-- 		kbd.msg = "fumbol"
-- 	end,
-- })
