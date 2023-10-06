return {
	{
		"neogitorg/neogit",
		dependencies = "nvim-lua/plenary.nvim",
		cmd = "Neogit",
		-- event = "VeryLazy",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
			{ "<leader>gb", "<cmd>Neogit branch<cr>", desc = "Neogit branch" },
			{ "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit commit" },
			{ "<leader>gp", "<cmd>Neogit push<cr>", desc = "Neogit push" },
		},
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
