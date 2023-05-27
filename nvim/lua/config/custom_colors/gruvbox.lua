return function()
	vim.o.background = "dark"
	vim.cmd.hi({ args = { "link  Operator GruvboxOrangeSign" }, bang = true }) -- +-=etc
	vim.cmd.hi({ args = { "link  Special GruvboxBlue" }, bang = true }) --(){}[],
	vim.cmd.hi({ args = { "link  String GruvboxFg3" }, bang = true }) -- strings in ""
	vim.cmd.hi({ args = { "link  Identifier GruvboxAqua" }, bang = true }) -- vars and fields
	vim.cmd.hi({ args = { "link  Function GruvboxRed" }, bang = true })
	vim.cmd.hi({ args = { "link  Keyword GruvboxYellow" }, bang = true })
	vim.cmd.hi({ args = { "link  MsgArea GruvboxGray" }, bang = true })
	vim.cmd.hi({ args = { "link  Type GruvboxBlue" }, bang = true })
	vim.cmd.hi({ args = { "link  @lsp.type.typeParameter GruvboxPurple" }, bang = true })
end
