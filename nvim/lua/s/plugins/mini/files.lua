return {
	"echasnovski/mini.files",
	version = false,
	keys = {
		{
			"-",
			function()
				require("mini.files").open()
			end,
			desc = "Toggle Mini Files",
		},
	},
	main = "mini.files",
	config = function(_, opts)
		require("mini.files").setup(opts)
		-- vim.cmd.hi({ args = { "link  MiniFilesNormal Normal" }, bang = true })
		--use this to add extra hi groups to transparent list
		-- vim.g.transparent_groups = vim.list_extend(
		-- 	vim.g.transparent_groups or {},
		-- 	vim.tbl_map(function(v)
		-- 		return v.hl_group
		-- 	end, vim.tbl_values({ "MiniFilesNormal" }))
		-- )
	end,
	opts = true,
}
