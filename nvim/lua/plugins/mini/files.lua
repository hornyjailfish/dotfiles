return {
	"echasnovski/mini.files",
	version = false,
	keys = {
		{
			"-",
			function()
				require("mini.files").open()
			end,
			desc = "Toggle Mini Files",
		},
	},
	main = "mini.files",
	config = true,
	opts = {},
}
