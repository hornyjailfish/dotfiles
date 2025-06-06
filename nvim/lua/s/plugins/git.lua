local util = require("s.util")
return {
	{
		"neogitorg/neogit",
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		cmd = "Neogit",
		-- event = "VeryLazy",
		keys = {
			{ "<leader>Gg", "<cmd>Neogit<cr>",        desc = "Neogit" },
			{ "<leader>Gb", "<cmd>Neogit branch<cr>", desc = "Neogit branch" },
			{ "<leader>Gc", "<cmd>Neogit commit<cr>", desc = "Neogit commit" },
			{ "<leader>Gp", "<cmd>Neogit push<cr>",   desc = "Neogit push" },
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
		event = "FileReadPost",
		keys = {
			{ "<leader>Gs", "<cmd>Gitsigns stage_hunk<cr>",   desc = "Stage hunk" },
			{ "<leader>GS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage buffer" },
			{ "<leader>GB", "<cmd>Gitsigns blame<cr>",        desc = "Blame buffer" },
			{ '<leader>h', "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Show hunk inline" },
			{ "[h", "<cmd>Gitsigns prev_hunk<cr>",        desc = "Previous hunk" },
			{ "]h", "<cmd>Gitsigns next_hunk<cr>",        desc = "Next hunk" },
		},
		config = function(_,opts)
			if vim.g.transparent_enabled then
				vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, {
					"GitSignsAdd",
					"GitSignsChange",
					"GitSignsDelete",
					"GitSignsStagedAdd",
					"GitSignsStagedChange",
					"GitSignsStagedDelete",
				})
				local cursor = Snacks.util.color("CursorLine", "bg")
				util.hl.update_highlights("GitSignsAddCul", { bg = cursor, fg = Snacks.util.color("GitSignsAddCul") })
				util.hl.update_highlights("GitSignsChangeCul",
					{ bg = cursor, fg = Snacks.util.color("GitSignsChangeCul") })
				util.hl.update_highlights("GitSignsDeleteCul",
					{ bg = cursor, fg = Snacks.util.color("GitSignsDeleteCul") })
			end

			-- require("gitsigns").setup(opts)
		end
	},
	-- {
	-- 	"tpope/vim-fugitive",
	-- 	cmd = "G",
	-- 	event = "DiffUpdated",
	-- },
}
