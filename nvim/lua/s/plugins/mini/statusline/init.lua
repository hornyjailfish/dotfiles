-- utils.init()
local combined = require("s.plugins.mini.statusline.sections")

return {
	{
		"nvim-mini/mini.statusline",
		version = false,
		lazy = false,
		priority = 8888,
		dependencies = {
			"nvim-mini/mini.icons",
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
