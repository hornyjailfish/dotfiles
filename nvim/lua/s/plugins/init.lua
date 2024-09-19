require("s.config")
return {
	{
		"nvim-lua/plenary.nvim",
	},
	{ "tpope/vim-sleuth" },
	{
		"MunifTanjim/nui.nvim",
	},
	{
		"stevearc/dressing.nvim",
		lazy = false,
		opts = {},
	},
	-- {
	-- 	"uga-rosa/ccc.nvim",
	-- 	config = true
	-- },
	-- {
	-- 	"rktjmp/shipwright.nvim", -- disabled rn
	-- },
	{
		"stevearc/overseer.nvim",
		keys = {
			{ "<leader>cg", "<cmd>OverseerRun<cr>",    desc = "Overseer Run" },
			{ "<leader>ce", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer window" },
		},
		opts = {
			task_list = {
				direction = "bottom",
			},
		},
	},
	{
		"ecthelionvi/NeoComposer.nvim",
		dependencies = {
			{
				"kkharji/sqlite.lua",
				config = function()
					if vim.fn.has("win32") == 1 then
						vim.g.sqlite_clib_path = vim.fs.normalize("./sqlite3.dll")
					end
				end,
			},
			-- { "echasnovski/mini.statusline" },
		},
		lazy = true,
		opts = function()
			return {}
		end,
		config = function(_, opts)
			-- vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, {
			--  "ComposerNormal", "ComposerTitle",
			-- 			"ComposerBoarder",
			-- 		}
			-- )
			-- "NormalFloat"
			require("NeoComposer").setup(opts or {})
		end,
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
	{
		"kawre/leetcode.nvim",
		lazy = true,
		build = ":TSUpdate html",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- required by telescope
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
