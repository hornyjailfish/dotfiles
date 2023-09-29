-- BUG: sometimes not working if which-key not loaded?
return {
	"echasnovski/mini.comment",
	event = "BufReadPre",
	opts = {
		options = {
			custom_commentstring = function()
				return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
			end,
		},
		hooks = {
			pre = function()
				return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
			end,
		},
	},

	config = function(_, opts)
		require("mini.comment").setup(opts)
	end,
}
