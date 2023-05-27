-- i dont use it most of the time because of capital letter for jumping
return {
	"rlane/pounce.nvim",
	cmd = { "Pounce" },
	keys = {
		{ "s", "<cmd>Pounce<cr>", desc = "Pounce" },
		{ "S", "<cmd>PounceRepeat<cr>", desc = "Pounceagain" },
	},
	opts = {
		--change for homerow layout
		accept_keys = "NTESIROAMGKLDPVJBHUCFYXW:QZ",

		accept_best_key = "<enter>",
		multi_window = true,
		debug = false,
	},
}
