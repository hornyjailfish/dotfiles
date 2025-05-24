-- TODO: automaticly add pined bufers to Graple.nvim(do i need it?) and Portal.nvim throu pined bufers
return {
	"axkirillov/hbac.nvim",
	dependencies = { "echasnovski/mini.bufremove" },
	keys = {
		{ "<leader>bD", "<cmd>Hbac close_unpinned<cr>", desc = "Delete not pined buffers" },
		{
			"<leader>b<space>",
			function()
				require("hbac").toggle_pin()
				if require("s.util").has("grapple") then
					if require("grapple").exists() == false then
						require("grapple").toggle()
					end
				end
				if require("s.util").has("neo-tree") then
					require("neo-tree.sources.manager").refresh("filesystem")
					require("neo-tree.sources.manager").refresh("buffers")
				end
				vim.cmd.redrawstatus()
			end,
			desc = "Pin or unpin current buffer",
		},
	},
	config = function()
		require("hbac").setup({
			autoclose = true, -- set autoclose to false if you want to close manually
			threshold = 3, -- hbac will start closing unedited buffers once that number is reached
			close_command = function(bufnr)
				require("mini.bufremove").delete(bufnr, false)
			end,
			pin_icons = {
				pinned = { " ", hl = "DiagnosticOk" },
				unpinned = { " ", hl = "DiagnosticError" },
			},
			close_buffers_with_windows = true, -- hbac will close buffers with associated windows if this option is `true`
		})
	end,
}
