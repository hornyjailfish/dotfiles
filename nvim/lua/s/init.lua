-- create global var for keymaps depends on it
-- @see util.layout().keymaps
vim.g.layout = "colemak"
-- vim.g.base_color = "#FFBE98"
vim.g.bg_color = ""
-- good colo
-- vim.g.base_color = "#939597"
-- vim.g.base_color = "#DECDBE"
-- vim.g.base_color = "#92A8D1"
vim.g.base_color = "#d3869b"

vim.g.enable_nushell_integration = true
vim.g.transparent_enabled = true

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

vim.o.background = require("s.util.theme").config.current_theme
-- vim.o.background = "dark"
-- vim.cmd.colo("gruvbox")
-- sry my eyes hurts on dark mode
-- vim.o.background = "light"
vim.cmd.colo("neobones")
