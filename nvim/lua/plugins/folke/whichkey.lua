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
		wk.register({
			mode = { "n", "v", "x" },
			["g"] = { name = "+goto" },
			["gs"] = { name = "+surround" },
			["]"] = { name = "+next" },
			["["] = { name = "+prev" },
			-- ["<leader><tab>"] = { name = "+tabs" },
			["<leader>b"] = { name = "+buffer" },
			["<leader>c"] = { name = "+code" },
			["<leader>C"] = { name = "+comment" },
			["<leader>f"] = { name = "+file/find" },

			-- setup git in nvim (code more MF)
			["<leader>g"] = { name = "+git" },
			-- ["<leader>gh"] = { name = "+hunks" },

			-- TODO: setup mini.session hotkey to save change session
			-- ["<leader>q"] = { name = "+quit/session" },
			["<leader>s"] = { name = "+search" },
			-- FIXME: pasting in visual mode dont change selected content if "+ not empty
			["<leader>p"] = { "Paste from system clipboard" },
			["<leader>y"] = { name = "Yank to system clipboard" },
			-- ["<leader>w"] = { name = "+windows" },

			["<leader>x"] = { name = "+diagnostics/quickfix" },
		})
	end,
}
