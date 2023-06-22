-- TODO: custom portals with hardcoded labels like d for defenition and t for treesitter parent e for error etc need to combine it manualy
-- local jumplist_opts = {
-- 	max_results = 4,
-- }
return {
	"cbochs/portal.nvim",
	keys = {
		{ "<leader>q", "<cmd>Portal quickfix backward<cr>", desc = "Portal through quickfix" },
		{ "<leader>g", "<cmd>Portal grapple backward<cr>", desc = "Jump back in Portal" },
		{ "<leader>m", "<cmd>Portal jumplist forward<cr>", desc = "Jump forward in Portal" },
		{
			"gi",
			function()
				require("portal.builtin").changelist.tunnel({})
			end,
			desc = "Jump changelist Portal",
		},
	},
	opts = {
		-- i dont like sorting of portals mostly need to fix it
		labels = { "n", "t", "e", "s" },
		select_first = true,
		---The raw window options used for the portal window
		window_options = {
			relative = "cursor",
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
		"LeonHeidelbach/trailblazer.nvim",
	},
}
