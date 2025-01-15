-- util have function that calls telescope with
-- cwd default to lazyvim.util.get_root
local Util = require("s.util")
return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	event = "BufRead",
	-- version = false, -- telescope did only one release, so use HEAD for now
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		-- {
		-- 	"<leader>,",
		-- 	-- "<cmd>Telescope buffers show_all_buffers=true theme=ivy previewer=false<cr>",
		-- 	function()
		-- 		require("hbac.telescope").pin_picker({
		-- 			layout_strategy = "horizontal",
		-- 			previewer = false,
		-- 			defaults = { theme = ivy },
		-- 		})
		-- 	end,
		-- 	desc = "Switch Buffer",
		-- },
		{ "<leader>/", Util.telescope("live_grep"), desc = "Find in Files (Grep)" },
		-- { "<leader><space>", Util.telescope("files", { cwd = false, previewer = false }), desc = "Find Files (cwd)" }, -- find
		{ "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
		{ "<leader>fF", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
		-- { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
		-- git
		-- { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
		-- { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
		-- TODO: move some telescope stuff under <leader>f keys??
		{ "<leader>ta", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		-- { "<leader>tb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
		--do i realy need it?
		-- { "<leader>tc", "<cmd>Telescope command_history theme=ivy<cr>", desc = "Command History" },
		{ "<leader>th", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
		-- { "<leader>tC", "<cmd>Telescope commands theme=ivy<cr>", desc = "Commands" },
		{ "<leader>tC", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
		-- { "<leader>tm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
		-- { "<leader>t:", "<cmd>Telescope command_history theme=ivy<cr>", desc = "Command History" },
		-- { "<leader>tg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
		-- { "<leader>tG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
		{ "<leader>tH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
		-- { "<leader>tk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
		-- { "<leader>to", "<cmd>Telescope vim_options<cr>", desc = "Options" },

		-- this is nice one but i dont think ss key is usefull for dat(can use <leader>fs)
		{
			"<leader>ss",
			Util.telescope("lsp_document_symbols", {
				symbols = {
					"Class",
					"Function",
					"Method",
					"Constructor",
					"Interface",
					"Module",
					"Struct",
					"Trait",
					"Field",
					"Property",
				},
			}),
			desc = "Goto Symbol",
		},
	},
	config = function()
		require("telescope").setup({
			defaults = {
				-- theme = "ivy",
				prompt_prefix = " ",
				selection_caret = " ",
				mappings = {
					i = {
						--mappings works at least idk why c-n not worked like c-e but it works with default setting
						[Util.keymap.down({ ctrl = true }, true)] = function()
							return require("telescope.actions").move_selection_next(vim.api.nvim_get_current_buf())
						end,
						[Util.keymap.up({ ctrl = true }, true)] = function()
							return require("telescope.actions").move_selection_previous(vim.api.nvim_get_current_buf())
						end,
						["<C-i>"] = function()
							Util.telescope("find_files", { no_ignore = true })()
						end,
						["<C-h>"] = function()
							Util.telescope("find_files", { hidden = true })()
						end,
						["<C-Down>"] = function(...)
							return require("telescope.actions").cycle_history_next(...)
						end,
						["<C-Up>"] = function(...)
							return require("telescope.actions").cycle_history_prev(...)
						end,
						--do i need it?
						["<c-t>"] = function(...)
							return require("trouble.providers.telescope").open_with_trouble(...)
						end,
					},
				},
			},
			-- extentions = {}
		})
	end,
}
