local template_dirs = { "s.overseer.template" }
local custom_templates = require("s.overseer.template")
local custom_actions = require("s.overseer.add_deps")
return {
	"stevearc/overseer.nvim",
	keys = {
		{ "<leader>cg", "<cmd>OverseerRun<cr>",         desc = "Overseer Run" },
		{ "<leader>ce", "<cmd>OverseerToggle<cr>",      desc = "Toggle Overseer window" },
		{ "<leader>ct", "<cmd>OverseerQuickAction<cr>", desc = "Overseer QuickAction" },
	},
	opts = {
		templates = vim.list_extend({ "builtin" }, custom_templates or {}),
		template_dirs = vim.list_extend({ "overseer.template" }, template_dirs or {}),
		actions = custom_actions,
	},
	config = true
}
