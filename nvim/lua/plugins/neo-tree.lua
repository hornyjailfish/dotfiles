local icons = require("config.icons").kinds
return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = {
			{
				"<leader>fe",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = require("util").get_root() })
				end,
				desc = "Explorer NeoTree (root dir)",
			},
			{ "<leader>fE", "<cmd>Neotree toggle<CR>", desc = "Explorer NeoTree (cwd)" },
			-- { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
			{ "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
		},
		opts = {
			enable_diagnostics = true,
			enable_git_status = true,
			sources = {
				"filesystem",
				"git_status",
				--omg document_symbols slow and sux
				"document_symbols",
			},
			filesystem = {
				hide_gitignored = true,
				hide_dotfiles = true,
			},
			follow_current_file = true,
			document_symbols = {
				follow_cursor = true,
				client_filters = "all",
				kinds = {
					File = { icon = icons.File, hl = "Tag" },
					Namespace = { icon = icons.Namespace, hl = "Include" },
					Package = { icon = icons.Package, hl = "Label" },
					Class = { icon = icons.Class, hl = "Include" },
					Property = { icon = icons.Property, hl = "@property" },
					Enum = { icon = icons.Enum, hl = "@number" },
					Function = { icon = icons.Function, hl = "Function" },
					String = { icon = icons.String, hl = "String" },
					Number = { icon = icons.Number, hl = "Number" },
					Array = { icon = icons.Array, hl = "Type" },
					Object = { icon = icons.Object, hl = "Type" },
					Key = { icon = icons.Key, hl = "" },
					Struct = { icon = icons.Struct, hl = "Type" },
					Operator = { icon = icons.Operator, hl = "Operator" },
					TypeParameter = { icon = icons.TypeParameter, hl = "Type" },
					StaticMethod = { icon = icons.Method, hl = "Function" },
				},
			},
			source_selectior = {
				statusline = false,
				winbar = true,
				sources = {
					{ source = "filesystem" },
					{ source = "git_status" },
					{ source = "document_symbols" },
				},
			},
		},
		init = function()
			if vim.fn.argc() == 1 then
				---@diagnostic disable-next-line: param-type-mismatch
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		config = function(_, opts)
			vim.g.neo_tree_remove_legacy_commands = 1
			require("neo-tree").setup(opts)
		end,
	},

	{
		-- only needed if you want to use the commands with "_with_window_picker" suffix
		"s1n7ax/nvim-window-picker",
		keys = {
			{
				"<leader>w",
				function()
					local _, color = require("nvim-web-devicons").get_icon_color_by_filetype(vim.bo.filetype)
					local picked_window_id = require("window-picker").pick_window({ other_win_hl_color = color })
						or vim.api.nvim_get_current_win()
					-- local bufnr = 2 -- Replace with the buffer number you want to check
					-- local buftype = vim.api.nvim_buf_get_option(picked_window_id, 'buftype')
					vim.api.nvim_set_current_win(picked_window_id)
				end,
				desc = "Pick a window",
			},
		},
		version = "v1.*",
		config = function()
			local _, color = require("nvim-web-devicons").get_icon_color_by_filetype(vim.bo.filetype)
			require("window-picker").setup({
				autoselect_one = true,
				include_current = false,
				selection_chars = "TNSERIAOCHPLFUWYQ;",
				filter_rules = {
					-- filter using buffer options
					bo = {
						-- if the file type is one of following, the window will be ignored
						filetype = { "neo-tree", "neo-tree-popup", "undotree", "notify" },

						-- if the buffer type is one of following, the window will be ignored
						buftype = { "terminal", "quickfix", "telescope" },
					},
				},
				current_win_hl_color = color,
			})
		end,
	},
}
