return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	dependencies = { "folke/twilight.nvim" },
	opts = {
		plugins = {
			twilight = { enable = true },
			alacritty = { enable = true },
			gitsigns = { enable = true },
		},
	},
}
