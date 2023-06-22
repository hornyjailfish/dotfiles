require("config")
return {
	{ "lewis6991/gitsigns.nvim", event = "BufReadPost", config = true },
	{
		-- dont like it because i cant preview diff while go through list
		"mbbill/undotree",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
		},
		config = function()
			vim.g.undotree_WindowLayout = 4
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
	},
	{
		-- daily notes naming need fixes
		"epwalsh/obsidian.nvim",
		event = { "BufReadPre " .. vim.fs.normalize("~/mind/**.md") },
		opts = {
			dir = "~/mind",
			daily_notes = {
				folder = "daily",
			},
			completion = {
				nvim_cmp = true,
			},
			templates = {
				subdir = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},
		},
	},
}
