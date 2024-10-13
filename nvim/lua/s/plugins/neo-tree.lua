local icons = require("s.config.icons").kinds
return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
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
					require("neo-tree.command").execute({ toggle = true, dir = require("s.util").get_root() })
				end,
				desc = "Explorer NeoTree (root dir)",
			},
			{ "<leader>fE", "<cmd>Neotree toggle<CR>", desc = "Explorer NeoTree (cwd)" },
			-- { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
			{ "<leader>E",  "<leader>fE",              desc = "Explorer NeoTree (cwd)", remap = true },
		},
		opts = {
			enable_diagnostics = true,
			enable_git_status = true,
			sources = {
				"filesystem",
				"git_status",
				"buffers",

				--omg document_symbols slow and sux
				-- "document_symbols",
			},
			buffers = {
				components = {
					pinned_bufer = function(config, node, state)
						if require("s.util").has("hbac.nvim") then
							local str = require("hbac.state").is_pinned(node.extra.bufnr) and "" or ""
							return {
								text = str,
								highlight = "DiagnosticError",
							}
						end
						return {}
					end,
				},
				renderers = {
					file = {
						{ "pinned_bufer" },
						{ "name",        use_git_status_colors = true },
						{ "diagnostics" },
						{ "git_status",  highlight = "NeoTreeDimText" },
					},
				},
			},
			filesystem = {
				hide_gitignored = true,
				hide_dotfiles = true,

				components = {
					grapple_tag = function(config, node, state)
						-- TODO: require can fail if grapple not exist/loaded
						-- grapple will loazyloads when not needed so i need add sections from grapple setup function
						if require("grapple").exists({ file_path = node:get_id() }) then
							local tag = require("grapple").key({ file_path = node:get_id() })
							return {
								text = string.format(" ⥤ %s", tag), -- <-- Add your favorite harpoon like arrow here
								highlight = config.highlight or "NeoTreeDirectoryIcon",
							}
						else
							return {}
						end
					end,
				},
				renderers = {
					file = {
						{ "icon" },
						{ "name",       use_git_status_colors = true },
						{ "grapple_tag" },
						{ "diagnostics" },
						{ "git_status", highlight = "NeoTreeDimText" },
					},
				},
			},
			follow_current_file = true,
			window = {
				width = 40,
			},
			source_selectior = {
				statusline = false,
				winbar = true,
				sources = {
					{ source = "filesystem" },
					{ source = "git_status" },
					-- { source = "document_symbols" },
				},
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function(file_path)
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
				{
					event = "before_render",
					handler = function(state)
						-- local components = state.components
						-- local file_renderer = state.renderers.file
					end,
				},
				{
					event = "neo_tree_buffer_enter",
					handler = function()
						-- vim.o.showmode = false
						-- vim.o.ruler = false
						-- vim.o.laststatus = 0
						-- vim.o.showcmd = false
					end,
				},
				{
					event = "neo_tree_buffer_leave",
					handler = function()
						-- vim.o.showmode = true
						-- vim.o.ruler = true
						-- vim.o.laststatus = 2
						-- vim.o.showcmd = true
					end,
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
			-- require("neo-tree.events.queue").define_event(buffer_pinned, {
			-- 	setup = function()
			-- 		return
			-- 	end,
			-- 	seed = function() end,
			-- 	teardown = function() end,
			-- 	debounce_frequency = 1000,
			-- 	once = false,
			-- 	cancelled = false,
			-- })
			vim.g.neo_tree_remove_legacy_commands = 1
			require("neo-tree").setup(opts)
		end,
	},

}
