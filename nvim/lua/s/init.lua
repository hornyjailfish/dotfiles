-- create global var for keymaps depends on it
-- @see util.layout().keymaps
vim.g.layout = "colemak"

vim.g.transparent_enabled = false

require("lazy").setup({
	spec = {
		{ import = "s.plugins" },
		{ import = "s.plugins.folke" },
		{ import = "s.plugins.mini" },
	},
	checker = {
		enabled = false,
		notify = true,
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

-- vim.o.background = "dark"
-- vim.cmd.colo("gruvbox")
-- sry my eyes hurts on dark mode
vim.o.background = "light"
vim.cmd.colo("neobones")
