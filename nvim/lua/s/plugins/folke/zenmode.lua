return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	enabled = false,
	dependencies = { "folke/twilight.nvim" },
	lazy = true,
	opts = {
		plugins = {
			twilight = { enable = true },
			alacritty = { enable = true },
			gitsigns = { enable = true },
		},
	},
}
