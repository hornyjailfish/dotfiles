local function create_tag()
	if require("grapple").exists() then
		require("grapple").toggle()
		return
	end
	local prompt = "Input name for tag "
	local tag = ""
	tag = vim.fn.input({ prompt = prompt .. "->", cancelreturn = "\b" })
	if tag == "\b" then
		return
	end
	if tag ~= "" then
		local opts = {
			key = tag,
		}
		require("grapple").tag(opts)
	else
		require("grapple").toggle()
	end
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
			"<leader>bn",
			function()
				require("grapple").cycle_forward()
			end,
			desc = "next Grapple tag",
		},
		{
			"<leader>be",
			function()
				require("grapple").cycle_backward()
			end,
			desc = "previous Grapple tag",
		},
		{
			"<leader>bT",
			function()
				require("grapple").popup_tags()
			end,
			desc = "Grapple tags popup",
		},
	},
	dependencies = { "nvim-lua/plenary.nvim" },
	config = true,
}
