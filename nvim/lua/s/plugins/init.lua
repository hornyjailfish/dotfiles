require("s.config")
return {
	{
		"nvim-lua/plenary.nvim",
		lazy = false,
	},

	{
		"stevearc/dressing.nvim",
		lazy = false,
		opts = {},
	},

	{ "tpope/vim-sleuth" },

	{
		"MunifTanjim/nui.nvim",
	},

	{
		"laytan/cloak.nvim",
		lazy = false,
		config = true,
	},

	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
	},

	-- {
	-- 	"uga-rosa/ccc.nvim",
	-- 	config = true
	-- },
	{
		"stevearc/overseer.nvim",
		keys = {
			{ "<leader>cg", "<cmd>OverseerRun<cr>",         desc = "Overseer Run" },
			{ "<leader>ce", "<cmd>OverseerToggle<cr>",      desc = "Toggle Overseer window" },
			{ "<leader>ct", "<cmd>OverseerQuickAction<cr>", desc = "Overseer QuickAction" },
		},
		opts = {
			task_list = {
				direction = "bottom",
			},
		},
	},

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
		event = {
			"BufReadPre " .. vim.fs.normalize("~/mind/**.md"), "BufReadPre " .. vim.fs.normalize("~/infra/**.md")
		},
		init = function()
			vim.wo.conceallevel = 1
		end,
		opts = {
			workspaces = {
				{ name = "mind",  path = "~/mind" },
				{ name = "infra", path = "~/infra" }
			},
			daily_notes = {
				folder = "daily",
			},
			completion = {
				nvim_cmp = true,
				min_chars = 2
			},
			templates = {
				subdir = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},
		},
	},

	{
		"nvzone/typr",
		cmd = { "Typr", "TyprStats" },
		dependencies = "nvzone/volt",
		enabled = true,
		opts = {},
	},

	{
		"kawre/leetcode.nvim",
		lazy = true,
		build = ":TSUpdate html",
		dependencies = {
			-- "nvim-telescope/telescope.nvim",
			-- "nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",

			-- optional
			"nvim-treesitter/nvim-treesitter",
			-- "rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			lang = "rust",
		},
	},
}
