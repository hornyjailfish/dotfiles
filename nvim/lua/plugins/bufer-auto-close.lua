-- TODO: automaticly add pined bufers to Gradle.nvim(do i need it?) and Portal.nvim throu pined bufers
return {
	"axkirillov/hbac.nvim",
	dependencies = { "echasnovski/mini.bufremove" },
	keys = {
		{ "<leader>bD", "<cmd>Hbac close_unpinned<cr>", desc = "Delete not pined buffers" },
		{ "<leader>b<space>", "<cmd>Hbac toggle_pin<cr>", desc = "Pin or unpin current buffer" },
	},
	config = function()
		require("hbac").setup({
			autoclose = true, -- set autoclose to false if you want to close manually
			threshold = 3, -- hbac will start closing unedited buffers once that number is reached
			close_command = function(bufnr)
				require("mini.bufremove").delete(bufnr, false)
			end,
			close_buffers_with_windows = true, -- hbac will close buffers with associated windows if this option is `true`
		})
	end,
}
