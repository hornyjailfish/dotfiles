return {
	"folke/todo-comments.nvim",
	cmd = { "TodoTrouble", "TodoTelescope" },
	event = "BufReadPost",
	config = true,
	keys = {
		-- idk but i hate this hotkeys
		{ "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
		{ "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
		{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
	},
}
