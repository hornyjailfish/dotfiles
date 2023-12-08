require("config")
return {
	{
		"MunifTanjim/nui.nvim",
	},
	{
		"rktjmp/shipwright.nvim",
	},
	{
		"ecthelionvi/NeoComposer.nvim",
		dependencies = {
			"kkharji/sqlite.lua",
			config = function()
				if vim.fn.has("win32") == 1 then
					vim.g.sqlite_clib_path = vim.fs.normalize("~/scoop/apps/sqlite/sqlite3.dll")
				end
			end,
		},
		lazy = true,
		opts = function()
			local hl = vim.api.nvim_get_hl_by_name("StatusLine", true)
			if hl.background == nil then
				hl.background = "none"
			else
				hl.background = string.format("#%06x", hl.background)
			end
			return {
				colors = {
					bg = hl.background,
				},
			}
		end,

		config = function(_, opts)
			vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, {
				"PlayingSymbol",
				"RecordingSymbol",
				"DelaySymbol",
				"ComposerNormal",
				"ComposerTitle",
				"ComposerBoarder",
			})
			require("NeoComposer").setup(opts)
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
	-- {
	-- 	"Dhanus3133/LeetBuddy.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- 	opts = {
	-- 		language = "rs",
	-- 	},
	-- 	config = true,
	-- 	keys = {
	-- 		{ "<leader>lq", "<cmd>LBQuestions<cr>", desc = "List Questions" },
	-- 		{ "<leader>ll", "<cmd>LBQuestion<cr>", desc = "View Question" },
	-- 		{ "<leader>lr", "<cmd>LBReset<cr>", desc = "Reset Code" },
	-- 		{ "<leader>lt", "<cmd>LBTest<cr>", desc = "Run Code" },
	-- 		{ "<leader>ls", "<cmd>LBSubmit<cr>", desc = "Submit Code" },
	-- 	},
	-- },
}
