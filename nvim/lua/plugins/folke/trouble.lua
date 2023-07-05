return {
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
}
