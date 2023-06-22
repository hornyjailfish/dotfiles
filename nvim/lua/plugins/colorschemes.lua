return {
	--plugin for easy transparent bg groups
	--
	--use this to add extra hi groups to transparent list
	-- vim.g.transparent_groups = vim.list_extend(
	--   vim.g.transparent_groups or {},
	--   vim.tbl_map(function(v)
	--     return v.hl_group
	--   end, vim.tbl_values(require('bufferline.config').highlights))
	-- )
	{
		"xiyaowong/nvim-transparent",
		name = "transparent",
		opts = {
			groups = {
				"Normal",
				"NormalNC",
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
				"LineNr",
				"NonText",
				"SignColumn",
				"CursorLineNr",
				"EndOfBuffer",
			},
			extra_groups = {
				"StatusLine",
				"StatusLineNC",
				-- sometimes i like it sometimes not
				-- "DiagnosticSignError",
				-- "DiagnosticSignWarn",
				-- "DiagnosticSignHint",
				-- "DiagnosticSignInfo",
			},
			exclude_groups = {},
		},
	},

	{
		---TOOOOKKKKIIIIOOOO
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			transparent = vim.g.transparent_enabled,
			-- night, storm, moon, day
			style = "night",
			sidebars = { "qf", "vista_kind", "terminal", "lazy", "undotree", "diff", "neo-tree", "telescope" },
		},
	},
	{
		"mcchrish/zenbones.nvim",
		lazy = true,
		config = function()
			local name = "zenbones"
			vim.g.bones_compat = 1
			vim.api.nvim_set_var(name, {
				darkness = "warm",

				-- use vim.g.transparent_enabled with nvim-transparent is prefered way
				transparent_background = vim.g.transparent_enabled,
				-- transparent_background = true,

				lighten_comments = 30,
				darken_comments = 30,
			})
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		config = function()
			require("gruvbox").setup({
				-- contrast = "soft",
				-- transparent_mode = true,
				transparent_mode = vim.g.transparent_enabled,
			})
		end,
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
