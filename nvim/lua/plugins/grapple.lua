local function create_tag()
	if require("grapple").exists() then
		require("grapple").toggle()
		require("neo-tree.sources.manager").refresh("filesystem")
		require("neo-tree.sources.manager").refresh("buffers")
		return
	end
	local prompt = "Input name for tag "
	local tag = ""
	tag = vim.fn.input({ prompt = prompt .. "->", cancelreturn = "\b" })
	if tag == "\b" then
		require("neo-tree.sources.manager").refresh("filesystem")
		require("neo-tree.sources.manager").refresh("buffers")
		return
	end
	if tag ~= "" then
		local opts = {
			name = tag,
		}
		require("grapple").tag(opts)
	else
		require("grapple").toggle()
	end
	require("neo-tree.sources.manager").refresh("filesystem")
	require("neo-tree.sources.manager").refresh("buffers")
	require("neo-tree.events").fire_event("grapple_event")
end

return {
	"cbochs/grapple.nvim",
	event = "BufReadPost",
	keys = {
		{
			"<leader>bt",
			function()
				create_tag()
			end,
			desc = "Create Grapple tag for buffer",
		},
		{
			"<F1>",
			function()
				require("grapple").select({ index = 1 })
			end,
			desc = "1 tag",
		},
		{
			"<F2>",
			function()
				require("grapple").select({ index = 2 })
			end,
			desc = "2 tag",
		},
		{
			"<F3>",
			function()
				require("grapple").select({ index = 3 })
			end,
			desc = "3 tag",
		},
		{
			"<F4>",
			function()
				require("grapple").select({ index = 4 })
			end,
			desc = "4 tag",
		},
		{
			"<leader>.",
			function()
				require("grapple").cycle_forward()
			end,
			desc = "next Grapple tag",
		},
		{
			"<leader>,",
			function()
				require("grapple").cycle_backward()
			end,
			desc = "previous Grapple tag",
		},
		{
			"<leader>bT",
			function()
				require("grapple").toggle_tags()
			end,
			desc = "Grapple tags popup",
		},
	},
	dependencies = { "nvim-lua/plenary.nvim" },
	config = true,
}
