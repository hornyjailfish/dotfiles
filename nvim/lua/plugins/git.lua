return {
	-- {
	-- 	"TimUntersberger/neogit",
	-- 	cmd = "Neogit",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		disable_buildin_notifications = true,
	-- 	},
	{ "lewis6991/gitsigns.nvim", event = "BufReadPost", config = true },
	{
		"tpope/vim-fugitive",
		cmd = "G",
		event = "DiffUpdated",
	},
}
