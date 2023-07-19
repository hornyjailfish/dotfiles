return {
	{
		"neogitorg/neogit",
    dependencies = 'nvim-lua/plenary.nvim',
		cmd = "Neogit",
		event = "VeryLazy",
		opts = {
			disable_buildin_notifications = false,
      integration = {
        telescope = true,
      },
		},
  },
	{ "lewis6991/gitsigns.nvim", event = "BufReadPost", config = true },
	-- {
	-- 	"tpope/vim-fugitive",
	-- 	cmd = "G",
	-- 	event = "DiffUpdated",
	-- },
}
