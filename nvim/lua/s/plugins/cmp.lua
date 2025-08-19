local map = require("s.util.keymap").map
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
			-- {
			-- 	"<tab>",
			-- 	function()
			-- 		if vim.snippet.active({ direction = 1 }) then
			-- 			return '<cmd>lua vim.snippet.jump(1)<cr>'
			-- 		else
			-- 			-- if utils.has("Codeium") then
			-- 			-- 	vim.fn["codeium#Accept"]()
			-- 			-- end
			-- 			if utils.has("supermaven-nvim") then
			-- 				local suggestion = require('supermaven-nvim.completion_preview')
			-- 				if suggestion.has_suggestion() then
			-- 					suggestion.on_accept_suggestion()
			-- 				end
			-- 			end
			-- 			-- return '<Tab>'
			-- 		end
			-- 	end,
			-- 	expr = true,
			-- 	-- silent = true,
			-- 	mode = "i",
			-- },
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
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered()
				},
				completion = {
					completeopt = "menu,noinsert,preview",
				},
				snippet = {
					expand = function(args)
						-- require("luasnip").lsp_expand_or_jumpable(args.body)
						if utils.has("supermaven-nvim") then
							local suggestion = require('supermaven-nvim.completion_preview')
							if suggestion.has_suggestion() then
								suggestion.on_accept_suggestion()
							end
						end
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<Up>"] = cmp.mapping.select_prev_item(select_opts),
					["<Down>"] = cmp.mapping.select_next_item(select_opts),
					-- [utils.keymap.up({ ctrl = true }, true)] = cmp.mapping.select_prev_item(select_opts),
					-- [utils.keymap.down({ ctrl = true }, true)] = cmp.mapping.select_next_item(select_opts),
					[map.c("up", true)] = cmp.mapping.select_prev_item(select_opts),
					[map.c("down", true)] = cmp.mapping.select_next_item(select_opts),
					["<C-Space>"] = cmp.mapping.complete(select_opts),
					["<C-z>"] = cmp.mapping.abort(),
					-- Acept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
				}),
				view = {
					entries = { name = "custom", selection_order = "near_cursor" },
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp",    group_index = 2 },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "codeium" },
					{ name = "supermaven" },
					{ name = "cody",        group_index = 3 },
					{ name = "lazydev",     group_index = 1 },
					-- TODO: add sources from plugins in dat plug initialization?
					{ name = "obsidian_new" },
					{ name = "obsidian" },
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
}
