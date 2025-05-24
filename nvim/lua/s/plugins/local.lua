return {
	{
		dir = "~/local.nvim/dualism.nvim",
		name = "dualism",
		enabled = false,
		lazy = false,
		keys = {
			{ "<leader>r",
				function()
					require("lazy").reload({ plugins = { "dualism" } })
				end
			},
		},
		opts = {
			color = vim.g.base_color,
			transparent = vim.g.transparent_enabled,
			generation = {
				type = vim.g.generation_type,
			}
		},
		config = function(_, opts)
			require("dualism").setup(opts)
			-- vim.cmd.color("dualism")
		end,
	},
}
