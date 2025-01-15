return {
	"folke/trouble.nvim",
	cmd = { "Trouble" },
	event = "LspAttach",
	opts = {
		height = 5,
		auto_close = true,
		-- auto_open = true,
		use_diagnostic_signs = true,
		preview = {
			scratch = false
		},
	},
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
		-- { "<leader>xX", "<cmd>Trouble workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
	},
}
