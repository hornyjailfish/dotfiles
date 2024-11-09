local hl = require("s.util.hl")
return function()
	if vim.o.background == "dark" then
		local n = hl.get("NormalFloat")
		local b = hl.get("FloatBorder")
		vim.api.nvim_set_hl(0, "FloatBorder", { fg = b.fg, bg = n.bg })
		return {}
	else
		return {}
	end
end
