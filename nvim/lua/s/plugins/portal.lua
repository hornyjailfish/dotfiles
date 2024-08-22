-- TODO: custom portals with hardcoded labels like d for defenition and t for treesitter parent e for error etc need to combine it manualy
-- local jumplist_opts = {
-- 	max_results = 4,
-- }
return {
	"cbochs/portal.nvim",
	keys = {
		{ "<leader>q", "<cmd>Portal quickfix backward<cr>", desc = "Portal through quickfix" },
		{ "<leader>l", "<cmd>Portal grapple backward<cr>", desc = "Jump back in Portal" },
		{
			"<leader>m",
			function()
				require("portal.builtin").jumplist.tunnel({
					slots = {
						function(value)
							return value.buffer == vim.fn.bufnr()
						end,
					},
				})
			end,
			desc = "Jumplist portal",
		},
		{
			"<leader>i",
			function()
				require("portal.builtin").changelist.tunnel({})
			end,
			desc = "Jump changelist Portal",
		},
	},
	opts = {
		-- i dont like sorting of portals mostly need to fix it
		labels = { "n", "e", "i", "o" },
		select_first = true,
		---The raw window options used for the portal window
		window_options = {
			relative = "win",
			width = 100,
			height = 4,
			col = 4,
			focusable = false,
			border = "single",
			noautocmd = true,
		},
	},
	dependencies = {
		"cbochs/grapple.nvim",
		--- really?
		-- "LeonHeidelbach/trailblazer.nvim",
	},
}
