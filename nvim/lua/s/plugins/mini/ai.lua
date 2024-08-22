-- better? text-objects
return {
	"echasnovski/mini.ai",
	keys = {
		{ "a", mode = { "x", "o" } },
		{ "i", mode = { "x", "o" } },
	},
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			init = function()
				-- no need to load the plugin, since we only need its queries
				require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
			end,
		},
	},
	opts = function()
		local ai = require("mini.ai")
		return {
			n_lines = 300,
			custom_textobjects = {
				o = ai.gen_spec.treesitter({
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}, {}),
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
			},
			mappings = {
				-- Main textobject prefixes
				around = 'a',
				inside = 'i',

				-- Next/last variants
				around_next = 'an',
				inside_next = 'in',
				around_last = 'al',
				inside_last = 'il',

				-- Move cursor to corresponding edge of `a` textobject
				goto_left = 'g[',
				goto_right = 'g]',
			},
		}
	end,
	config = function(_, opts)
		local ai = require("mini.ai")
		ai.setup(opts)
	end,
}
