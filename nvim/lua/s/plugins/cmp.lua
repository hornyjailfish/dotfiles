local utils = require("s.util")
return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- Library items can be absolute paths
				-- "~/projects/my-awesome-lib",
				-- Or relative, which means they will be resolved as a plugin
				-- "LazyVim",
				-- When relative, you can also provide a path to the library in the plugin dir
				"luvit-meta/library", -- see below
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
	-- snippets FU
	--
	-- {
	-- 	"L3MON4D3/LuaSnip",
	-- 	event = "LspAttach",
	-- 	dependencies = {
	-- 		-- "rafamadriz/friendly-snippets",
	-- 		-- config = function()
	-- 		-- 	require("luasnip.loaders.from_vscode").lazy_load()
	-- 		-- end,
	-- 	},
	-- 	opts = {
	-- 		history = false,
	-- 		-- sometimes this not helps...still jumpable
	-- 		region_check_events = "InsertEnter",
	-- 		delete_check_events = "TextChanged",
	-- 	},
	-- 	keys = {
	-- 		{
	-- 			"<tab>",
	-- 			function()
	-- 				local snip = false
	-- 				local ai = false
	-- 				if utils.has("LuaSnip") then
	-- 					snip = (require("luasnip").expand_or_locally_jumpable(1))
	-- 				end
	-- 				if utils.has("Codeium") then
	-- 					ai = vim.fn["codeium#Accept"]()
	-- 				end
	-- 				return snip
	-- 					or ai
	-- 					or "/t"
	-- 			end,
	-- 			expr = true,
	-- 			silent = true,
	-- 			mode = "i",
	-- 		},
	-- 		-- {
	-- 		-- 	"<tab>",
	-- 		-- 	function()
	-- 		-- 		if utils.has("LuaSnip") then
	-- 		-- 			require("luasnip").jump(1)
	-- 		-- 		end
	-- 		-- 	end,
	-- 		-- 	mode = "s",
	-- 		-- },
	-- 		{
	-- 			"<s-tab>",
	-- 			function()
	-- 				if utils.has("LuaSnip") then
	-- 					require("luasnip").jump(-1)
	-- 				end
	-- 			end,
	-- 			mode = { "i", "s" },
	-- 		},
	-- 	},
	-- },

	-- auto completion
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertCharPre",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			-- {"hrsh7th/cmp-buffer", event = "VeryLazy"},
			{ "hrsh7th/cmp-path", event = "InsertCharPre", lazy = true },
			-- "saadparwaiz1/cmp_luasnip",
		},
		keys = {
			{
				"<tab>",
				function()
					if vim.snippet.active({ direction = 1 }) then
						return '<cmd>lua vim.snippet.jump(1)<cr>'
					else
						return '<Tab>'
					end
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
			{
				"<S-tab>",
				function()
					if vim.snippet.active({ direction = -1 }) then
						return '<cmd>lua vim.snippet.jump(-1)<cr>'
					else
						return '<S-Tab>'
					end
				end,
				expr = true,
				silent = true,
				mode = "i",
			},



		},
		opts = function()
			local cmp = require("cmp")
			local select_opts = { behavior = cmp.SelectBehavior.Insert }
			return {
				completion = {
					completeopt = "menu,noinsert,preview",
				},
				snippet = {
					expand = function(args)
						-- require("luasnip").lsp_expand_or_jumpable(args.body)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({

					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<Up>"] = cmp.mapping.select_prev_item(select_opts),
					["<Down>"] = cmp.mapping.select_next_item(select_opts),
					[utils.keymap.up({ ctrl = true }, true)] = cmp.mapping.select_prev_item(select_opts),
					[utils.keymap.down({ ctrl = true }, true)] = cmp.mapping.select_next_item(select_opts),
					["<C-y>"] = cmp.mapping.complete(select_opts),
					["<C-z>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				view = {
					entries = { name = "custom", selection_order = "near_cursor" },
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
					-- { name = "luasnip" },
					{ name = "codeium" },

					{ name = "cody" },
					{ name = "lazydev", group_index = 0 },

					-- TODO: add sources from plugins in dat plug initialization?
					-- { name = "obsidian_new" },
					-- { name = "obsidian" },
				}),
				formatting = {
					format = function(entry, item)
						local icons = require("mini.icons").list("lsp")
						local icons = require("s.config.icons").kinds

						if icons[item.kind] then
							item.kind = icons[item.kind]
						end
						-- Source
						item.menu = ({
							nvim_lsp = "[LSP]",
							buffer = "[Buffer]",
							cody = "[Cody]",
							codeium = "[]",
							obsidian = "[Obsidian]",
							nvim_lua = "[Lua]",
							luasnip = "[snip]",
							lazydev = "[nvim]",
							path = "[path]",
							latex_symbols = "[LaTeX]",
						})[entry.source.name]
						return item
					end,
				},
				experimental = {
					-- ghost_text = {
					-- 	hl_group = "LspCodeLens",
					-- },
				},
			}
		end,
	},
	-- {
	-- 	'saghen/blink.cmp',
	-- 	lazy = false, -- lazy loading handled internally
	-- 	-- optional: provides snippets for the snippet source
	-- 	dependencies = 'rafamadriz/friendly-snippets',
	--
	-- 	-- use a release tag to download pre-built binaries
	-- 	version = 'v0.*',
	-- 	-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- 	-- build = 'cargo build --release',
	--
	-- 	opts = {
	-- 		highlight = {
	-- 			-- sets the fallback highlight groups to nvim-cmp's highlight groups
	-- 			-- useful for when your theme doesn't support blink.cmp
	-- 			-- will be removed in a future release, assuming themes add support
	-- 			use_nvim_cmp_as_default = true,
	-- 		},
	-- 		-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
	-- 		-- adjusts spacing to ensure icons are aligned
	-- 		nerd_font_variant = 'mono',
	--
	-- 		-- experimental auto-brackets support
	-- 		-- accept = { auto_brackets = { enabled = true } }
	-- 	}
	-- }
}
