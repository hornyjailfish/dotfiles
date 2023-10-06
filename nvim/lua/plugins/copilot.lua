return {

	{
		"sourcegraph/sg.nvim",
		event = "BufRead",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			download_binaries = true,
			enable_cody = true,
			on_attach = function(client, buffer)
				require("util.init").on_attach(function(client, buffer) end)
			end,
		},
	},
	{
		name = "Codeium",
		"Exafunction/codeium.vim",
		event = "InsertEnter",
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
