return {
	"echasnovski/mini.pick",
	event = "VeryLazy",
	cmd = "Pick",
	lazy = true,
	main = "mini.pick",
	keys = {
		{
			"<leader>,",
			function()
				MiniPick.builtin.buffers()
			end,
			desc = "Switch Buffer",
		},
		{
			"<leader>/",
			function()
				MiniPick.builtin.grep_live()
			end,
			desc = "Find in Files (Grep)",
		},
		{
			"<leader><space>",
			function()
				MiniPick.builtin.files()
			end,
			desc = "Find Files (cwd)",
		}, -- find
		{
			"<leader>fr",
			function()
				MiniPick.registry.oldfiles()
			end,
			desc = "Recent",
		},
		-- { "<leader>ta", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		{ "<leader>tb", "<cmd>Pick lines<cr>", desc = "Buffer" },
		--do i realy need it?
		{ "<leader>t:", "<cmd>Pick history<cr>", desc = "Command History" },
		{ "<leader>th", "<cmd>Pick help<cr>", desc = "Help Pages" },
		{ "<leader>tm", "<cmd>Pick marks<cr>", desc = "Jump to Mark" },
		{ "<leader>tk", "<cmd>Pick keymaps<cr>", desc = "Key Maps" },
		{ "<leader>to", "<cmd>Pick options<cr>", desc = "Options" },
	},
	config = function()
		require("mini.pick").setup({
			mappings = {
				-- caret_left = "<Left>",
				-- caret_right = "<Right>",

				-- choose = "<CR>",
				-- choose_in_split = "<C-s>",
				-- choose_in_tabpage = "<C-t>",
				-- choose_in_vsplit = "<C-v>",
				-- choose_marked = "<M-CR>",
				--
				-- delete_char = "<BS>",
				-- delete_char_right = "<Del>",
				-- delete_left = "<C-u>",
				-- delete_word = "<C-w>",
				--
				-- mark = "<C-x>",
				-- mark_all = "<C-a>",
				move_down = "<C-n>",
				move_start = "<C-g>",
				move_up = "<C-e>",

				paste = "<C-r>",

				refine = "<C-Space>",
				refine_marked = "<M-Space>",

				scroll_down = "<C-f>",
				scroll_left = "<C-h>",
				scroll_right = "<C-l>",
				scroll_up = "<C-b>",

				stop = "<Esc>",

				toggle_info = "<S-Tab>",
				toggle_preview = "<Tab>",
			},
		})
		vim.cmd.hi({ args = { "link  MiniPickNormal Normal" }, bang = true })
		--use this to add extra hi groups to transparent list
		vim.g.transparent_groups = vim.list_extend(
			vim.g.transparent_groups or {},
			vim.tbl_map(function(v)
				return v.hl_group
			end, vim.tbl_values({ "MiniPickNormal" }))
		)
	end,
}
