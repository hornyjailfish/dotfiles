return {
	{
		"neogitorg/neogit",
		dependencies = "nvim-lua/plenary.nvim",
		cmd = "Neogit",
		-- event = "VeryLazy",
		opts = {
			disable_builtin_notifications = true,
			integration = {
				telescope = true,
			},
		},
	},
	{ "lewis6991/gitsigns.nvim", event = "BufReadPost", config = true },
	-- {
	-- 	"tpope/vim-fugitive",
	-- 	cmd = "G",
	-- 	event = "DiffUpdated",
	-- },
}
