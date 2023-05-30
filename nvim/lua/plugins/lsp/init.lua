return {
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			{ "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"nvim-lua/lsp-status.nvim",
		},
		---@class PluginLspOpts
		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
			},
			-- Automatically format on save
			autoformat = true,
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the LazyVim formatter,
			-- but can be also overriden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			---@type lspconfig.options
			servers = {
				jsonls = {},
				pylsp = {},
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
				rust_analyzer = {
					settings = {
						["rust_analyzer"] = {
							imports = {
								granularity = {
									group = "module",
								},
								prefix = "self",
							},
							assist = {
								importgranularity = "module",
								importprefix = "by_self",
							},
							cargo = {
								loadoutdirsfromcheck = true,
								-- features = { "bevy/dynamic" },
							},
							procmacro = {
								enable = true,
							},
							checkOnSave = {
								command = "clippy",
							},
						},
					},
				},
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
			if plugin.servers then
				require("util").deprecate("lspconfig.servers", "lspconfig.opts.servers")
			end
			if plugin.setup_server then
				require("util").deprecate("lspconfig.setup_server", "lspconfig.opts.setup[SERVER]")
			end

			-- setup autoformat
			require("plugins.lsp.format").autoformat = opts.autoformat

			-- setup formatting and keymaps
			require("util").on_attach(function(client, buffer)
				require("plugins.lsp.format").on_attach(client, buffer)
				require("plugins.lsp.keymaps").on_attach(client, buffer)
				if package.loaded["illuminate"] then
					require("illuminate").on_attach(client)
				end
				if package.loaded["lsp-status"] ~= nil then
					require("lsp-status").register_progress()
					require("lsp-status").config({
						kind_labels = require("config.icons").kinds,
						indicator_errors = require("config.icons").diagnostics.Error,
						indicator_warnings = require("config.icons").diagnostics.Warn,
						indicator_info = require("config.icons").diagnostics.Info,
						indicator_hint = require("config.icons").diagnostics.Hint,
						indicator_ok = require("config.icons").diagnostics.Hint,
					})
					require("lsp-status").on_attach(client)
				end
			end)

			-- diagnostics
			for name, icon in pairs(require("config.icons").diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
			vim.diagnostic.config(opts.diagnostics)

			local servers = opts.servers
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			vim.tbl_extend("keep", capabilities or {}, require("lsp-status").capabilities)
			require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
			require("mason-lspconfig").setup_handlers({
				function(server)
					local server_opts = servers[server] or {}
					server_opts.capabilities = capabilities
					if opts.setup[server] then
						if opts.setup[server](server, server_opts) then
							return
						end
					elseif opts.setup["*"] then
						if opts.setup["*"](server, server_opts) then
							return
						end
					end
					require("lspconfig")[server].setup(server_opts)
				end,
			})
		end,
	},

	-- formatters
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufReadPre",
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			return {
				sources = {
					-- nls.builtins.formatting.prettierd,
					nls.builtins.formatting.stylua,
					nls.builtins.diagnostics.flake8,
				},
			}
		end,
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
				require("util").deprecate("treesitter.ensure_installed", "treesitter.opts.ensure_installed")
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