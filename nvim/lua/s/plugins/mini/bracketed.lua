return {
	"nvim-mini/mini.bracketed",
	event = "BufReadPost",
	main = "mini.bracketed",
	config = true,
	opts = {
		-- First-level elements are tables describing behavior of a target:
		--
		-- - <suffix> - single character suffix. Used after `[` / `]` in mappings.
		--   For example, with `b` creates `[B`, `[b`, `]b`, `]B` mappings.
		--   Supply empty string `''` to not create mappings.
		--
		-- - <options> - table overriding target options.
		--
		-- See `:h MiniBracketed.config` for more info.

		comment = { suffix = "c", options = {} },
		conflict = { suffix = "x", options = {} },
		diagnostic = { suffix = "d", options = {} },
		indent = { suffix = "i", options = {} },
		location = { suffix = "l", options = {} },
		quickfix = { suffix = "q", options = {} },
		treesitter = { suffix = "t", options = {} },
		window = { suffix = "w", options = {} },
		yank = { suffix = "y", options = {} },
		-- things i dont need/like for [
		buffer = { suffix = "", options = nil },
		jump = { suffix = "", options = nil },
		file = { suffix = "", options = nil },
		oldfile = { suffix = "", options = nil },
		undo = { suffix = "", options = nil },
	},
}
