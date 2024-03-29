return {
	-- snippets FU
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		dependencies = {
			-- "rafamadriz/friendly-snippets",
			-- config = function()
			-- 	require("luasnip.loaders.from_vscode").lazy_load()
			-- end,
		},
		opts = {
			history = false,
			-- sometimes this not helps...still jumpable
			region_check_events = "InsertEnter",
			delete_check_events = "TextChanged",
		},
		keys = {
			{
				"<tab>",
				function()
					return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or vim.fn["codeium#Accept"]()
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
			{
				"<tab>",
				function()
					require("luasnip").jump(1)
				end,
				mode = "s",
			},
			{
				"<s-tab>",
				function()
					require("luasnip").jump(-1)
				end,
				mode = { "i", "s" },
			},
		},
	},

	-- auto completion
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			-- "saadparwaiz1/cmp_luasnip",
		},
		opts = function()
			local cmp = require("cmp")
			local select_opts = { behavior = cmp.SelectBehavior.Insert }
			return {
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<Up>"] = cmp.mapping.select_prev_item(select_opts),
					["<Down>"] = cmp.mapping.select_next_item(select_opts),
					[require("util").keymap.up({ ctrl = true }, true)] = cmp.mapping.select_prev_item(select_opts),
					[require("util").keymap.down({ ctrl = true }, true)] = cmp.mapping.select_next_item(select_opts),
					["<C-Space>"] = cmp.mapping.complete(select_opts),
					["<C-x>"] = cmp.mapping.abort(),
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
					{ name = "luasnip" },
					{ name = "cody" },
					{ name = "codeium" },

					-- TODO: add sources from plugins in dat plug initialization?
					{ name = "obsidian_new" },
					{ name = "obsidian" },
				}),
				formatting = {
					format = function(entry, item)
						local icons = require("config.icons").kinds

						if icons[item.kind] then
							item.kind = icons[item.kind]
						end
						-- Source
						item.menu = ({
							nvim_lsp = "[LSP]",
							buffer = "[Buffer]",
							cody = "[Cody]",
							codeium = "[Codeium]",
							obsidian = "[Obsidian]",
							nvim_lua = "[Lua]",
							luasnip = "[snip]",
							path = "[path]",
							latex_symbols = "[LaTeX]",
						})[entry.source.name]
						return item
					end,
				},
				experimental = {
					ghost_text = {
						hl_group = "LspCodeLens",
					},
				},
			}
		end,
	},
}
