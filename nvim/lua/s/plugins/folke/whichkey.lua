return {
	"folke/which-key.nvim",
	event = "BufEnter",
	opts = {
		plugins = { spelling = true },
		trigers_blacklist = {
			--something makes heavy lag on < insert mode now i fix it but...
			-- i = { "<" },
		},
	},
	config = function(_, opts)
		-- i moved it into main options file
		-- vim.o.timeout = true
		-- vim.o.timeoutlen = 40

		local wk = require("which-key")
		wk.setup(opts)
		wk.add({
			{
				mode = { "n", "v", "x" },
				{ "<leader>C", group = "comment" },
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>p", desc = "Paste from system clipboard" },
				{ "<leader>s", group = "search" },
				{ "<leader>x", group = "diagnostics/quickfix" },
				{ "<leader>y", group = "Yank to system clipboard" },
				{ "[",         group = "prev" },
				{ "]",         group = "next" },
				{ "g",         group = "goto" },
				{ "gs",        group = "surround" },
			},
		})
	end,
}
