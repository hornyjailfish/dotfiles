local map = require("s.util.keymap").map
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
				{ map.l("b"), group = "buffer" },
				{ map.l("c"), group = "code" },
				{ map.l("f"), group = "file/find" },
				{ map.l("G"), group = "git" },
				{ map.l("p"), desc = "Paste from system clipboard" },
				{ map.l("s"), group = "search" },
				{ map.l("x"), group = "diagnostics/quickfix" },
				-- { "<leader>y", group = "Yank to system clipboard" },
				{ "[",         group = "prev" },
				{ "]",         group = "next" },
				{ "g",         group = "goto" },
				{ "gs",        group = "surround" },
			},
		})
	end,
}
