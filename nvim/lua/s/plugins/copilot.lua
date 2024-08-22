return {
	{
		"sourcegraph/sg.nvim",
		event = "InsertEnter",
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
				require("s.util").on_attach(function(client, buffer) end)
			end,
		},
	},
	-- {
	-- 	"Exafunction/codeium.nvim",
	-- 	main = "codeium",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	event = "InsertEnter",
	--
	-- 	opts = {
	-- 		config_path = vim.fs.normalize("~/.codeium/config.json"),
	-- 		bin_path = vim.fs.normalize("~/.codeium/bin/"),
	-- 		api = {
	-- 			host = "server.codeium.com",
	-- 			port = "443",
	-- 			path = "/",
	-- 			portal_url = "codeium.com",
	-- 		},
	-- 		enable_chat = false,
	-- 		enable_local_search = false,
	-- 	},
	-- 	config = true,
	-- },
	{
		name = "Codeium",
		"Exafunction/codeium.vim",
		-- event = "InsertEnter",
		-- keys = {
		-- 	{
		-- 		"<tab>",
		-- 		function()
		-- 			vim.fn["codeium#Accept"]()
		-- 		end,
		-- 		expr = true,
		-- 		silent = true,
		-- 		mode = "i",
		-- 	},
		-- 	{
		-- 		"<M-]>",
		-- 		function()
		-- 			vim.fn["codeium#CycleOrComplete"]()
		-- 		end,
		-- 		expr = true,
		-- 		silent = true,
		-- 		mode = "i",
		-- 	},
		-- },
		config = function()
			vim.g.codeium_bin = vim.fs.normalize("~/.codeium/bin/")
			vim.g.codeium_tab_fallback = "<tab>"
			vim.g.codeium_filetypes = {
				markdown = false,
			}
			-- vim.g.codeium_no_map_tab = 1
			-- vim.g.codeium_disable_keymaps = 1
			vim.g.codeium_manual = 1
		end,
	},
}
