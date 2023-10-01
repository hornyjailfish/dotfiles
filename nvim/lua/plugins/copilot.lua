return {
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
}
