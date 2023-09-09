require("config")
return {
	{
		"rktjmp/shipwright.nvim",
	},
	{
		"roobert/tabtree.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<Tab>",
				function()
					require("tabtree").next()
				end,
				"Next delimiter",
			},
			{
				"<S-Tab>",
				function()
					require("tabtree").previous()
				end,
				"Previous delimiter",
			},
		},
		-- (parameters) @parameters
		-- (argument) @arguments
		-- (identifier) @field
		-- (punctuation) @punctuation
		opts = {
			debug = true,
			-- use :InspectTree to discover the (capture group)
			-- @capture_name can be anything
			language_configs = {
				python = {
					target_query = [[
              (string) @string_capture
              (interpolation) @interpolation_capture
              (parameters) @parameters_capture
              (argument_list) @argument_list_capture
            ]],
					-- experimental feature, to move the cursor in certain situations like when handling python f-strings
					offsets = {
						string_start_capture = 1,
					},
				},
				lua = {
					target_query = [[
              (string) @string
		          (arguments) @arguments
		          (field) @value 
          ]],
					offsets = {
						string_start_capture = 1,
					},
				},
				html = {
					target_query = [[
              (tag_name) @tag.element
              (attribute) @property
              (attribute_value) @string
              (text) @text.html
            ]],
					-- experimental feature, to move the cursor in certain situations like when handling python f-strings
					offsets = {
						string_start_capture = 1,
					},
				},
			},
			default_config = {
				target_query = [[
			        ]],
				offsets = {},
			},
		},
		config = function(_, opts)
			require("tabtree").setup(opts)
		end,
	},
	{
		"ecthelionvi/NeoComposer.nvim",
		dependencies = {
			"kkharji/sqlite.lua",
			config = function()
				vim.g.sqlite_clib_path = vim.fs.normalize("~/scoop/apps/sqlite/sqlite3.dll")
			end,
		},
		lazy = true,
		opts = {
			colors = {
				bg = "DiagnosticSignError",
			},
		},
		config = function(_, opts)
			require("NeoComposer").setup(opts)
			-- local line = require("mini.statusline").active()
			-- print(line)
			-- vim.cmd.redrawstatus()
			-- local bg = vim.api.nvim_get_hl(0,{})["SignColumn"].bg
			-- bg = string.format("#%x",bg)
			-- -- print(bg)
			-- vim.api.nvim_set_hl(0, "RecordingSymbol", {bg = bg })
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
