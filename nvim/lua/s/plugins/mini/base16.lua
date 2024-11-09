return {
	'echasnovski/mini.base16',
	name = "mini.base16",
	version = false,
	enabled = false,
	config = function()
		local pal = require("s.util.colorgen.generate")
		local bg1 = pal.hex.bg.dark.dim
		local bg2 = pal.hex.bg.dark.base
		local fg = pal.hex.bg.light.base
		if vim.o.background=="light" then
			bg1 = pal.hex.bg.light.dim
			bg2 = pal.hex.bg.light.base
			fg = pal.hex.bg.dark.base
		end
		--- 00 = Background
		--- 01 = CurLine, SignCol
		--- 02 = StatusLine bg Visual bg
		--- 03 = SignCol fg, Comment
		--- 04 = CursorLineNr fg, MiniStatuslineDevInfo fg
		--- 05 = MiniStatuslineModeInsert bg, Variable fg, Normal fg
		--- 06 =
		--- 07 =
		--- 08 = Identifier MiniStatuslineModeCommand
		--- 09 = Boolean
		--- 0A =
		--- 0B = Strings
		--- 0C = Special
		--- 0D = Functions
		--- 0E = Keyword
		--- 0F = Delimiter
		local palette = {
			base00 = bg2,
			base01 = bg1,
			-- base02 = bg1,
			base02 = pal.hex.i_gray,
			base03 = pal.hex.gray,
			base04 = pal.hex.gray,
			base05 = pal.hex.gray,
			base06 = pal.hex.gray,
			base07 = pal.hex.gray,
			base08 = pal.hex.dim.split_complement_l,
			base09 = pal.hex.dim.split_complement_r,
			base0A = pal.hex.dim.base,
			base0B = pal.hex.dim.triadic_l,
			base0C = pal.hex.dim.base,
			base0D = pal.hex.dim.analog_l,
			base0E = pal.hex.base.base,
			base0F = pal.hex.gray,
		}

		require("mini.base16").setup({
				palette = palette,
			})
	end
}
