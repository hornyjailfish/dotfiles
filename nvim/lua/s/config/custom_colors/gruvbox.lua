return function()
	-- vim.o.background = "dark"
	vim.cmd.hi({ args = { "link  Operator GruvboxFg0" }, bang = true }) -- +-=etc
	vim.cmd.hi({ args = { "link  Special GruvboxBlue" }, bang = true }) --(){}[],
	vim.cmd.hi({ args = { "link  @punctuation.bracket GruvboxBlueBold" }, bang = true }) --()
	vim.cmd.hi({ args = { "link  @punctuation.delimiter GruvboxFg1" }, bang = true }) -- strings in ""
	vim.cmd.hi({ args = { "link  String GruvboxFg3" }, bang = true }) -- strings in ""
	vim.cmd.hi({ args = { "link  Identifier GruvboxAqua" }, bang = true }) -- vars and fields
	vim.cmd.hi({ args = { "link  @field GruvboxAquaBold" }, bang = true }) -- vars and fields
	vim.cmd.hi({ args = { "link  Function GruvboxRed" }, bang = true })
	vim.cmd.hi({ args = { "link  Keyword GruvboxYellow" }, bang = true })
	vim.cmd.hi({ args = { "link  @keyword GruvboxYellowBold" }, bang = true })
	vim.cmd.hi({ args = { "link  @keyword.return GruvboxYellowBold" }, bang = true })
	vim.cmd.hi({ args = { "link  @keyword.function GruvboxAquaBold" }, bang = true })
	vim.cmd.hi({ args = { "link  @keyword.operator GruvboxRedBold" }, bang = true })
	vim.cmd.hi({ args = { "link  Exception GruvboxRedBold" }, bang = true })
	-- vim.cmd.hi({ args = { "link  MsgArea GruvboxGray" }, bang = true })
	vim.cmd.hi({ args = { "link  Type GruvboxBlue" }, bang = true })
	vim.cmd.hi({ args = { "link  EndOfBuffer SignColumn" }, bang = true })
	vim.cmd.hi({ args = { "link GitSignsAdd GruvboxGreenSign" }, bang = true })
	vim.cmd.hi({ args = { "link GitSignsChange GruvboxOrangeSign" }, bang = true })
	vim.cmd.hi({ args = { "link GitSignsDelete GruvboxRedSign" }, bang = true })
	-- vim.cmd.hi({ args = { "link  SignColumn Normal" }, bang = true })
	vim.cmd.hi({ args = { "link  @lsp.type.typeParameter GruvboxPurple" }, bang = true })
	-- vim.cmd.hi({ args = { "link  @lsp.mod.declaration GrappleBold" }, bang = true })

	local palette = require("gruvbox").palette
	return palette
end
