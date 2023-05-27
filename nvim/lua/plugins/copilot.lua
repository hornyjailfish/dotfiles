return {
	name = "Codeium",
	"Exafunction/codeium.vim",
	event = "InsertEnter",
	-- keys = {
	-- 	{
	-- 		"<S-spc>",
	-- 		function()
	-- 			vim.fn["codeium#Clear"]()
	-- 		end,
	-- 		mode = "i",
	-- 		expr = true,
	-- 		desc = "Clear suggestions",
	-- 	},
	-- 	{
	-- 		"<A-]>",
	-- 		function()
	-- 			vim.fn["codeium#CycleCompletions"](1)
	-- 		end,
	-- 		{ mode = "i", expr = true, desc = "Next suggestions" },
	-- 	},
	-- 	{
	-- 		"<A-[>",
	-- 		function()
	-- 			vim.fn["codeium#CycleCompletions"](-1)
	-- 		end,
	-- 		{ mode = "i", expr = true, desc = "Previous suggestions" },
	-- 	},
	-- 	{
	-- 		"<c-spc>",
	-- 		function()
	-- 			vim.fn["codeium#Accept"]()
	-- 		end,
	-- 		{ mode = "i", expr = true, desc = "Accept suggestions" },
	-- 	},
	-- 	{
	-- 		"<A-Bslash>",
	-- 		function()
	-- 			vim.fn["codeium#Complete"]()
	-- 		end,
	-- 		{ mode = "i", expr = true, desc = "Trigger Codeium suggestions" },
	-- 	},
	-- },
	config = function()
		vim.g.codeium_filetypes = {
			markdown = false,
		}

		-- vim.g.codeium_no_map_tab = 1
		-- vim.g.codeium_disable_keymaps = 1
		vim.g.codeium_manual = 1
	end,
}
