-- utils.init()
local combined = require("s.plugins.mini.statusline.sections")

return {
	{
		"echasnovski/mini.statusline",
		version = false,
		lazy = false,
		priority = 8888,
		dependencies = {
			"echasnovski/mini.icons",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("mini.statusline").setup({
				content = {
					active = combined.active,
					inactive = combined.inactive,
				},
				use_icons = true,
			})
		end,
	},
}
