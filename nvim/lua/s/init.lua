-- create global var for keymaps depends on it
-- @see util.layout().keymaps
vim.g.layout = "colemak"
vim.g.transparent_enabled = true

require("lazy").setup({
	spec = {
		{ import = "s.plugins.folke" },
		{ import = "s.plugins.mini" },
		{ import = "s.plugins" },
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
vim.o.background = "dark"
vim.cmd.colo("gruvbox")
-- vim.cmd.redrawstatus()
