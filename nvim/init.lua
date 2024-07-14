local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- create global var for keymaps depends on it
-- @see util.layout().keymaps
vim.g.layout = "colemak"

require("lazy").setup({
	spec = {
		{ import = "plugins.folke" },
		{ import = "plugins.mini" },
		{ import = "plugins" },
	},
	checker = {
		enabled = false,
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				"rplugin",
				-- thanks treesitter
				-- "syntax",
				-- thanks matchup
				"matchit",
				"matchparen",
			},
		},
	},
})

-- dont lazyload colorschemes they say
vim.o.background = "dark"
vim.g.transparent_enabled = true
vim.cmd.colo("gruvbox")
-- vim.cmd.redrawstatus()
