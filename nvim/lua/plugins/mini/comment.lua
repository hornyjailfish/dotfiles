-- BUG: sometimes not working if which-key not loaded?
return {
	"echasnovski/mini.comment",
	event = "BufReadPre",
	opts = {
		hooks = {
			pre = function()
				require("ts_context_commentstring.internal").update_commentstring({})
			end,
		},
	},
	config = function(_, opts)
		require("mini.comment").setup(opts)
	end,
}
