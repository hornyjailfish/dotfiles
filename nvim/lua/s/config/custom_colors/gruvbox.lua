local Util = require("lazy.core.util")
local util = require("s.util")

return function()
	-- vim.o.background = "dark"
	util.hl.link("Operator", "GruvboxFg0")
	util.hl.link("Special", "GruvboxBlue")
	util.hl.link("@punctuation.bracket", "GruvboxBlueBold")
	util.hl.link("@punctuation.delimiter", "GruvboxFg1")
	util.hl.link("String", "GruvboxFg3")
	util.hl.link("Identifier", "GruvboxAqua")
	util.hl.link("@field", "GruvboxAquaBold")

	util.hl.link("Function", "GruvboxRed")
	util.hl.link("Keyword", "GruvboxYellow")
	util.hl.link("@keyword", "GruvboxYellowBold")
	util.hl.link("@keyword.return", "GruvboxYellowBold")
	util.hl.link("@keyword.function", "GruvboxAquaBold")
	util.hl.link("@keyword.operator", "GruvboxRedBold")
	util.hl.link("Exception", "GruvboxRedBold")
	util.hl.link("MsgArea", "GruvboxGray")
	util.hl.link("Type", "GruvboxBlue")
	util.hl.link("EndOfBuffer", "SignColumn")
	util.hl.link("GitSignsAdd", "GruvboxGreenSign")
	util.hl.link("GitSignsChange", "GruvboxOrangeSign")
	util.hl.link("GitSignsDelete", "GruvboxRedSign")
	-- util.hl.link("SignColumn","Normal")
	util.hl.link("@lsp.type.typeParameter", "GruvboxPurple")
	util.hl.link("@lsp.mod.declaration", "GrappleBold")
	if vim.g.transparent_enabled then
		Util.info("transparent enabled")
		vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, {
			"GruvboxRedSign",
			"GruvboxAquaSign",
			"GruvboxBlueSign",
			"GruvboxGreenSign",
			"GruvboxOrangeSign",
			"GruvboxPurpleSign",
			"GruvboxYellowSign",

			"GitSignsAdd",
			"GitSignsChange",
			"GitSignsDelete",

			"MiniPickNormal",

			"ComposerNormal",
			"ComposerTitle",
			"ComposerBorder",
		}
		)
	end

	local palette = require("gruvbox").palette
	-- return palette
end
