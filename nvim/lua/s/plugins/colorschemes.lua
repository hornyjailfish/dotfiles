return {
	--plugin for easy transparent bg groups
	--use this to add extra hi groups to transparent list
	--
	-- vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, { "ExtraGroup" })
	--
	{
		"xiyaowong/nvim-transparent",
		name = "transparent",
		opts = {
			groups = {
				"Normal",
				"NormalNC",
				"NormalFloat",
				"FloatBorder",
				"Comment",
				"Constant",
				"Special",
				"Identifier",
				"Statement",
				"PreProc",
				"Type",
				"Underlined",
				"Todo",
				"String",
				"Function",
				"Conditional",
				"Repeat",
				"Operator",
				"Structure",
				"LineNrAbove",
				-- "LineNr",
				"LineNrBelow",
				"NonText",
				"SignColumn",
				"MsgArea",
				-- "CursorLineNr",
				"EndOfBffer",
			},
			extra_groups = {
				-- sometimes i like it sometimes not
				-- "DiagnosticSignError",
				-- "DiagnosticSignWarn",
				-- "DiagnosticSignHint",
				-- "DiagnosticSignInfo",
			},
			exclude_groups = {
				-- "FloatBorder",
				-- "NormalFloat",
			},
		},
	},

	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			transparent = vim.g.transparent_enabled,
			-- night, storm, moon, day
			style = "moon",
			sidebars = { "qf", "vista_kind", "terminal", "lazy", "undotree", "diff", "neo-tree", "telescope" },
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colo("tokyonight")
		end,
	},
	{
		"mcchrish/zenbones.nvim",
		lazy = true,
		priority = 1000,
		config = function()
			local name = "seoulbones"
			vim.g.bones_compat = 1
			vim.api.nvim_set_var(name, {
				transparent_background = vim.g.transparent_enabled,
				colorize_diagnostic_underline_text = true,

				-- dark background opts
				lighten_comments = 30,
				darkness = "warm",
				lighten_noncurrent_window = true,

				-- light background opts
				darken_noncurrent_window = true,
				darken_comments = 0,
			})
			vim.cmd.colo(name)
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = true,
		config = function()
			require("gruvbox").setup({
				-- contrast = "hard",
				transparent_mode = vim.g.transparent_enabled,
			})
			vim.cmd.colo("gruvbox")
		end,
	},
	{
		"alexxGmZ/e-ink.nvim",
		config = true
	},
	{
		"catppuccin/nvim",
		lazy = true,
		name = "catppuccin",
		opts = {
			transparent_background = vim.g.transparent_enabled,
			-- transparent_background = true,

			intergations = {
				mini = true,
				gitsigns = true,
				mason = true,
				neotree = true,
				cmp = true,
				native_lsp = true,
				treesitter = true,
				pounce = true,
				telescope = true,
				lsp_trouble = true,
				which_key = true,
			},
		},
	},
}
