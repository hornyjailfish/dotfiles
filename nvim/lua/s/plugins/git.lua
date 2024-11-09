return {
	{
		"neogitorg/neogit",
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		cmd = "Neogit",
		-- event = "VeryLazy",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>",        desc = "Neogit" },
			{ "<leader>gb", "<cmd>Neogit branch<cr>", desc = "Neogit branch" },
			{ "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit commit" },
			{ "<leader>gp", "<cmd>Neogit push<cr>",   desc = "Neogit push" },
		},
		opts = {
			disable_builtin_notifications = true,
			integration = {
				telescope = true,
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPost",
		config = function()
			if vim.g.transparent_enabled then
				vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, {
					"GitSignsAdd",
					"GitSignsChange",
					"GitSignsDelete",
					"GitSignsStagedAdd",
					"GitSignsStagedChange",
					"GitSignsStagedDelete",
				}
				)
			end

			require("gitsigns").setup({})
		end
	},
	-- {
	-- 	"tpope/vim-fugitive",
	-- 	cmd = "G",
	-- 	event = "DiffUpdated",
	-- },
}
