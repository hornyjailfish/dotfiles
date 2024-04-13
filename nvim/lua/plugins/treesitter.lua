return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		-- lazy = false,
		event = "BufReadPre",
		---@type TSConfig
		opts = {
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			-- context_commentstring = { enable = true, enable_autocmd = false },
			ensure_installed = {
				"bash",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"rust",
				"typescript",
				"tsx",
				"vim",
				"vimdoc",
				"yaml",
			},
			textobjects = {
				enable = true,
			},
		},
		---@param opts TSConfig
		config = function(plugin, opts)
			if plugin.ensure_installed then
				require("lazyvim.util").deprecate("treesitter.ensure_installed", "treesitter.opts.ensure_installed")
			end
			require("nvim-treesitter.install").compilers = { "clang" }
			require("nvim-treesitter.configs").setup(opts)
			require("ts_context_commentstring").setup()
		end,
	},
	-- comments
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = true,
	},
	{
		"dariuscorvus/tree-sitter-surrealdb.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "BufReadPost",
		config = function()
			-- setup step
			require("tree-sitter-surrealdb").setup()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter" },
		event = "BufReadPost",
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = false,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["ia"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next = {
							["]a"] = "@block.outer",
						},
						goto_previous = {
							["[a"] = "@block.inner",
						},
					},
				},
			})
		end,
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		-- lazy = false,
		event = "BufReadPost",
		opts = {
			useDefaultKeymaps = true,
			disabledKeymaps = { "gc" },
		},
	},

	-- {
	-- 	"nvim-treesitter/playground",
	-- 	dependencies = { "nvim-treesitter" },
	-- 	cmd = "TSPlaygroundToggle",
	-- 	config = function()
	-- 		require("nvim-treesitter.configs").setup({
	-- 			playground = {
	-- 				enable = false,
	-- 				disable = {},
	-- 				updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
	-- 				persist_queries = false, -- Whether the query persists across vim sessions
	-- 				keybindings = {
	-- 					toggle_query_editor = "o",
	-- 					toggle_hl_groups = "i",
	-- 					toggle_injected_languages = "t",
	-- 					toggle_anonymous_nodes = "a",
	-- 					toggle_language_display = "I",
	-- 					focus_language = "f",
	-- 					unfocus_language = "F",
	-- 					update = "R",
	-- 					goto_node = "<cr>",
	-- 					show_help = "?",
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
	-- --silver surferer LUL i think its good
	{
		"theHamsta/crazy-node-movement",
		event = "BufReadPost",
		dependencies = { "nvim-treesitter", "nvim-treesitter-textobjects" },
		config = function()
			require("nvim-treesitter.configs").setup({
				node_movement = {
					enable = true,
					keymaps = {
						move_up = "<a-k>",
						move_down = "<a-j>",
						move_left = "<a-e>",
						move_right = "<a-n>",
						swap_left = "<s-a-n>", -- will only swap when one of "swappable_textobjects" is selected
						swap_right = "<s-a-e>",
						select_current_node = "<a-v>",
					},
					swappable_textobjects = { "@function.outer", "@parameter.inner", "@statement.outer" },
					allow_switch_parents = true, -- more craziness by switching parents while staying on the same level, false prevents you from accidentally jumping out of a function
					allow_next_parent = true, -- more craziness by going up one level if next node does not have children
				},
			})
			vim.cmd.hi({ args = { "link CrazyNodeMovementCurrent  CursorLineNr" }, bang = true })
		end,
	},
	--
	-- -- % with treesitter support need some exploration how to use it proper
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
		config = function()
			vim.g.loaded_matchit = 0
			vim.g.matchup_matchparen_enabled = 0
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
			if package.loaded["nvim-treesitter"] then
				require("nvim-treesitter.configs").setup({
					matchup = {
						-- disable = {}, -- mandatory, false will disable the whole extension
						enable = true, -- optional, list of language that will be disabled
						-- [options]
					},
				})
			end
		end,
	},
	{
		"roobert/tabtree.nvim",
		-- dev = true,
		-- dir = vim.fs.normalize("~\\gits\\tabtree.nvim"),
		-- name = "tabtree",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<Tab>",
				function()
					require("tabtree").next()
				end,
				"Next delimiter",
			},
			{
				"<S-Tab>",
				function()
					require("tabtree").previous()
				end,
				"Previous delimiter",
			},
		},
		-- (parameters) @parameters
		-- (argument) @arguments
		-- (identifier) @field
		-- (punctuation) @punctuation
		opts = {
			debug = true,
			-- use :InspectTree to discover the (capture group)
			-- @capture_name can be anything
			language_configs = {
				python = {
					target_query = [[
	             (string) @string_capture
	             (interpolation) @interpolation_capture
	             (parameters) @parameters_capture
	             (argument_list) @argument_list_capture
	           ]],
					-- experimental feature, to move the cursor in certain situations like when handling python f-strings
					offsets = {
						string_start_capture = 1,
					},
				},
				lua = {
					target_query = [[
		          (arguments) @arguments
		          (field) @value
	         ]],
					offsets = {
						string_start_capture = 1,
					},
				},
				surealdb = {
					target_query = [[
		          (token) @token
	         ]],
					offsets = {
						string_start_capture = 1,
					},
				},
				html = {
					target_query = [[
					         (tag_name) @tag.element
					         (attribute) @property
					         (attribute_value) @string
					         (text) @text.html
					       ]],
					-- experimental feature, to move the cursor in certain situations like when handling python f-strings
					offsets = {
						string_start_capture = 1,
					},
				},
				tsx = {
					target_query = [[
                      (template_string) @template
                      (statement_block) @block
                      (parenthesized_expression) @condition
                      (pair) @values
                     ]],
					-- (else_clause) @alternative
					-- (string_fragment) @string
					-- (argument) @identifier
					offsets = {
						string_start_capture = 0,
					},
				},
				typescript = {
					target_query = [[
	             (string_fragment) @string
		          (identifier) @identifier
		          (pair) @values
	         ]],
					offsets = {
						string_start_capture = 0,
					},
				},
				default_config = {
					target_query = [[
			        ]],
					offsets = {},
				},
			},
		},
		config = function(_, opts)
			-- local p = vim.fs.normalize("$LOCALAPPDATA/nvim-data/lazy/nvim-treesitter/parser/tsx.so")
			-- vim.treesitter.language.register('tsx', 'typescriptreact')
			-- vim.treesitter.language.add("tsx", {filetype = "typescriptreact", path = "tsx.so"})
			-- vim.filetype.add({
			--   extension = {
			--     tsx = "typescriptreact",
			--   }
			-- })
			require("tabtree").setup(opts)
		end,
	},
}
