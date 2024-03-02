return {

	{
		"sourcegraph/sg.nvim",
		event = "BufRead",
		-- commit = "0a3c7f76a5e81452b5d4bd78a7bb8cd2603445b5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			download_binaries = true,
			enable_cody = true,
			on_attach = function(client, buffer)
				require("util").on_attach(function(client, buffer) end)
			end,
		},
	},
	{
		name = "Codeium",
		"Exafunction/codeium.vim",
		event = "BufEnter",
		keys = {
			{
				"<tab>",
				function()
					vim.fn["codeium#Accept"]()
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
		},
		config = function()
			vim.g.codeium_filetypes = {
				markdown = false,
			}
			-- vim.g.codeium_no_map_tab = 1
			-- vim.g.codeium_disable_keymaps = 1
			vim.g.codeium_manual = 1
		end,
	},
}
