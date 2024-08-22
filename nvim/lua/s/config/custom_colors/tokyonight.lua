return function()
	-- INFO: returns wrong palette with light scheme
	local colors = require("tokyonight.colors").setup()
	local proc = require("tokyonight.util")
	-- vim.o.background = "dark"

	local str = proc.lighten(colors.blue7, 0.6)
	local con = proc.darken(colors.red, 0.7)
	local com = proc.darken(colors.blue7, 0.8)
	if vim.o.background == "dark" then
		-- --what i want to change
		-- -- Special(buildins functions)
		-- -- Type(too much blue)
		vim.api.nvim_set_hl(0, "Type", { fg = colors.cyan })
		vim.api.nvim_set_hl(0, "Special", { fg = colors.blue0 })
		vim.api.nvim_set_hl(0, "Function", { fg = colors.blue0 })
		vim.api.nvim_set_hl(0, "Constant", { fg = con })
		-- vim.api.nvim_set_hl(0, "@fields", { fg = colors.fg_dark })
		vim.api.nvim_set_hl(0, "@parameter", { fg = con })
		vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.fg })
		vim.api.nvim_set_hl(0, "@field", { fg = colors.fg_dark })
		vim.api.nvim_set_hl(0, "@property", { fg = colors.fg })
		vim.api.nvim_set_hl(0, "@keyword", { fg = colors.fg_dark })
		vim.api.nvim_set_hl(0, "@keyword.return", { fg = colors.red1 })
		vim.api.nvim_set_hl(0, "PreProc", { fg = colors.green2 })
		vim.api.nvim_set_hl(0, "Comment", { fg = com })

		vim.api.nvim_set_hl(0, "String", { fg = str })
		return colors
	else
		vim.api.nvim_set_hl(0, "String", { fg = str })
		return {}
	end
end
