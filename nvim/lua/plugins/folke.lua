--some general folke plugins
return {
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		event = "LspAttach",
		opts = {
			height = 5,
			auto_close = true,
			-- auto_open = true,
			use_diagnostic_signs = true,
		},
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
		},
	},
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = "BufReadPost",
		config = true,
    -- stylua: ignore
    keys = {
      -- idk but i hate this hotkeys
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
	},
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		dependencies = { "folke/twilight.nvim" },
		opts = {
			plugins = {
				twilight = { enable = true },
				alacritty = { enable = true },
				gitsigns = { enable = true },
			},
		},
	},
}
