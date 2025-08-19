-- create global var for keymaps depends on it
-- @see util.layout().keymaps
vim.g.layout = "qwerty"

vim.g.base_color = "#491B61"
-- vim.g.base_color = "#96B093"
-- vim.g.base_color = "#92A8D1"
-- vim.g.base_color = "#31ACC6"
-- vim.g.base_color = "#8E9F7F"
-- vim.g.base_color = "#5AD795"
-- vim.g.base_color = "#5DE8D9"
-- vim.g.base_color = "#2548A9"
-- vim.g.generation_type = "quadra"

vim.g.ft_color = "" -- it filled with current buffer filetype devicons hex color from Bufenter au

vim.g.enable_nushell_integration = false
vim.g.transparent_enabled = false



require("lazy").setup({
	spec = {
		{ import = "s.plugins" },
		{ import = "s.plugins.folke" },
		{ import = "s.plugins.overseer" },
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
				"syntax",
				-- thanks matchup
				"matchit",
				"matchparen",
			},
		},
	},
})

-- get windows light/dark settings
vim.o.background = require("s.util.theme").config.current_theme

-- vim.o.background = "dark"
-- vim.o.background = "light"
-- vim.cmd.colo("gruvbox")
-- vim.cmd.colo("dualism")
-- sry my eyes hurts on dark mode
vim.cmd.colo("e-ink")
-- vim.cmd.colo("tokyonight")
