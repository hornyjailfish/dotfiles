return {
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPost",
		dependencies = {
			{ "folke/neoconf.nvim",   cmd = "Neoconf", config = true },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			{ "b0o/schemastore.nvim", lazy = false },
			"nvim-lua/lsp-status.nvim",
		},
		---@class PluginLspOpts
		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = require("s.config.icons").diagnostics.Error,
						[vim.diagnostic.severity.WARN] = require("s.config.icons").diagnostics.Warn,
						[vim.diagnostic.severity.INFO] = require("s.config.icons").diagnostics.Info,
						[vim.diagnostic.severity.HINT] = require("s.config.icons").diagnostics.Hint,
					},
					linehl = {
						[vim.diagnostic.severity.ERROR] = 'DiffDelete',
					},
					numhl = {
						[vim.diagnostic.severity.WARN] = 'WarningMsg',
					},
				},
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
			},
			-- Automatically format on save
			autoformat = require("s.plugins.lsp.format").autoformat,
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the LazyVim formatter,
			-- but can be also overriden when specified
			-- format = {
			-- 	formatting_options = nil,
			-- 	timeout_ms = nil,
			-- },
			---@type lspconfig.options
			servers = {
				nushell = {},
				templ = {},
				ts_ls = {},
				-- jsonls = {
				-- 	settings = {
				-- 		json = {
				-- 			schemas = function()
				-- 				return require("schemastore").json.schemas({
				-- 					extra = {
				-- 						{
				-- 							description = "Meilisearch schema",
				-- 							fileMatch = "*.json",
				-- 							name = "*",
				-- 							url = "https://bump.sh/meilisearch/doc/meilisearch.json",
				-- 						},
				-- 					},
				-- 				})
				-- 			end,
				-- 			validate = { enable = false },
				-- 		},
				-- 	},
				-- },
				-- pyright = {},
				pylsp = {
					configurationSources = { "flake8" },
					plugins = {
						-- ruff = { enabled = true },
						-- pyflakes = { enabled = true },
						flake8 = { enabled = true },
						-- yapf = {
						-- 	enabled = true,
						-- 	based_on_style = "pep8",
						-- 	column_limit = 120,
						-- },
						mypy = {
							enabled = true,
							live_mode = true,
							strict = true,
						},
						isort = { enabled = true },
						-- rope = { enabled = true },
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								library = {
									-- "${3rd}/luv/library",
								},
								checkThirdParty = false,
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				-- rust_analyzer = {
				-- settings = {
				-- ["rust_analyzer"] = {
				-- imports = {
				-- 	granularity = {
				-- 		group = "module",
				-- 	},
				-- 	prefix = "self",
				-- },
				-- assist = {
				-- 	importgranularity = "module",
				-- 	importprefix = "by_self",
				-- },
				-- cargo = {
				-- loadoutdirsfromcheck = false,
				-- buildScripts = {
				-- enable = true,
				-- },
				-- },
				-- cargo = {
				-- 	loadoutdirsfromcheck = true,
				-- },
				-- procmacro = {
				-- 	enable = true,
				-- },
				-- checkOnSave = {
				-- 	command = "clippy",
				-- },
				-- },
				-- },
				-- },
			},
			-- you can do any additional lsp server setup here
			-- return true if you don't want this server to be setup with lspconfig
			---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				["*"] = function(server, opts) end,
			},
		},
		---@param opts PluginLspOpts
		config = function(plugin, opts)
			-- border override globally
			-- local border = {
			-- 	{ "🭽", "FloatBorder" },
			-- 	{ "▔", "FloatBorder" },
			-- 	{ "🭾", "FloatBorder" },
			-- 	{ "▕", "FloatBorder" },
			-- 	{ "🭿", "FloatBorder" },
			-- 	{ "▁", "FloatBorder" },
			-- 	{ "🭼", "FloatBorder" },
			-- 	{ "▏", "FloatBorder" },
			-- }
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or border or "rounded"
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end

			if plugin.servers then
				require("s.util").deprecate("lspconfig.servers", "lspconfig.opts.servers")
			end
			if plugin.setup_server then
				require("s.util").deprecate("lspconfig.setup_server", "lspconfig.opts.setup[SERVER]")
			end

			-- setup autoformat
			require("s.plugins.lsp.format").autoformat = opts.autoformat

			-- setup formatting and keymaps
			require("s.util").on_attach(function(client, buffer)
				require("s.plugins.lsp.format").on_attach(client, buffer)
				require("s.plugins.lsp.keymaps").on_attach(client, buffer)

				if require("s.util").has("illuminate") then
					require("illuminate").on_attach(client)
				end

				if require("s.util").has("sg.nvim") then
					require("sg").setup({
						on_attach = function(client, buffer) end,
					})
				end
				if require("s.util").has("lsp-status.nvim") then
					require("lsp-status").register_progress()
					require("lsp-status").config({
						kind_labels = require("s.config.icons").kinds,
						indicator_errors = require("s.config.icons").diagnostics.Error,
						indicator_warnings = require("s.config.icons").diagnostics.Warn,
						indicator_info = require("s.config.icons").diagnostics.Info,
						indicator_hint = require("s.config.icons").diagnostics.Hint,
						indicator_ok = require("s.config.icons").diagnostics.Hint,
					})
					require("lsp-status").on_attach(client)
				end
			end)

			-- diagnostics
			for name, icon in pairs(require("s.config.icons").diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
			vim.diagnostic.config(opts.diagnostics)

			local servers = opts.servers
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			capabilities = vim.tbl_extend("keep", capabilities or {}, require("lsp-status").capabilities)
			-- require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
			require("mason-lspconfig").setup_handlers({
				function(server)
					local server_opts = servers[server] or {}
					-- print(vim.inspect(server_opts))
					-- if server_opts.filetypes ~= {} then
					-- 	local default = require("lspconfig")[server].document_config.default_config.filetypes
					-- 	local filetypes = server_opts.filetypes
					-- 	server_opts.filetypes = vim.tbl_extend("force", default, { filetypes })
					-- end
					server_opts.capabilities = capabilities
					if opts.setup[server] then
						if opts.setup[server](server, server_opts) then
							return
						end
					elseif opts.setup["*"] then
						if opts.setup["*"](server, server_opts) then
							require("lspconfig")[server].setup(server_opts)
							return
						end
					end
					require("lspconfig")[server].setup(server_opts)
				end,
			})
			for name, opt in pairs(opts.servers) do
				-- opt.root_dir = require("lspconfig").util.root_pattern(require("util").get_root())
				require("lspconfig")[name].setup(opt)
			end
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	-- formatters
	-- {
	-- 	"nvimtools/none-ls.nvim",
	-- 	event = "BufReadPre",
	-- 	dependencies = { "mason.nvim" },
	-- 	opts = function()
	-- 		local nls = require("null-ls")
	-- 		local util = require("util").get_root()
	-- 		return {
	-- 			root_dir = require("null-ls.utils").root_pattern(
	-- 				util,
	-- 				".null-ls-root",
	-- 				".neoconf.json",
	-- 				"pyproject.toml",
	-- 				"Makefile",
	-- 				".git"
	-- 			),
	-- 			sources = {
	-- 				-- nls.builtins.formatting.prettierd,
	-- 				nls.builtins.formatting.stylua,
	-- 				-- nls.builtins.diagnostics.flake8,
	-- 				nls.builtins.diagnostics.tidy,
	-- 				nls.builtins.code_actions.gitsigns,
	-- 				nls.builtins.hover.printenv,
	-- 			},
	-- 		}
	-- 	end,
	-- },
	{
		"stevearc/conform.nvim",
		event = "BufReadPre",
		opts = {
			notify_on_error = true,
			-- format_on_save = {
			-- 	timeout_ms = 500,
			-- 	lsp_fallback = "prefer",
			-- },
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				python = { "flake8" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				javascript = { { "prettierd",  } },
			},
		},
	},

	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				"stylua",
				"shellcheck",
				"shfmt",
				"flake8",
			},
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(plugin, opts)
			if plugin.ensure_installed then
				require("s.util").deprecate("treesitter.ensure_installed", "treesitter.opts.ensure_installed")
			end
			require("mason").setup(opts)
			local mr = require("mason-registry")
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},
}
