-- utils from LazyVim distribution
-- at start i just clone it and rework everything besides lsp setups and default configs for telescope

local Util = require("lazy.core.util")

local M = {}

M.root_patterns = { ".git", "lua", "pyproject.toml", "Cargo.toml", "package.json", "tsconfig.json", "Makefile" }

-- I hate c-p c-n keymap so i create this to use it with colemak/qwerty
---@param name string
function M.layout(name)
	local function add_surround(str)
		return "<" .. str .. ">"
	end
	local function modifier(mod, str)
		local mod_map = {
			mod.ctrl and "C-" or "",
			mod.shift and "S-" or "",
			mod.alt and "A-" or "",
			str,
		}
		return table.concat(mod_map, "")
	end
	---@param str string
	---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
	---@param sur boolean
	local function create_mapstr(str, mod, sur)
		local str = str
		local mod = mod or {}
		if next(mod) == nil then
			return sur and add_surround(str) or str
		end
		str = modifier(mod, str)
		return sur and add_surround(str) or str
	end

	if name == "qwerty" then
		return {
			keymap = {
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean} modifiers
				---@param sur boolean surround with < >
				down = function(mod, sur)
					return create_mapstr("j", mod, sur)
				end,
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				up = function(mod, sur)
					return create_mapstr("k", mod, sur)
				end,
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				left = function(mod, sur)
					return create_mapstr("h", mod, sur)
				end,
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				right = function(mod, sur)
					return create_mapstr("l", mod, sur)
				end,
			},
		}
	elseif name == "colemak" then
		return {
			keymap = {
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				down = function(mod, sur)
					return create_mapstr("n", mod, sur)
				end,
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				up = function(mod, sur)
					return create_mapstr("e", mod, sur)
				end,
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				left = function(mod, sur)
					return create_mapstr("m", mod, sur)
				end,
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				right = function(mod, sur)
					return create_mapstr("i", mod, sur)
				end,
			},
		}
	end
end
-- shorthand for using global var
M.keymap = M.layout(vim.g.layout or "qwerty").keymap

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			-- recursion??
			on_attach(client, buffer)
		end,
	})
end

---@param plugin string
function M.has(plugin)
	return require("lazy.core.config").plugins[plugin] ~= nil
end

---@param name string
function M.opts(name)
	local plugin = require("lazy.core.config").plugins[name]
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
	---@type string?
	local path = vim.api.nvim_buf_get_name(0)
	path = path ~= "" and vim.loop.fs_realpath(path) or nil
	---@type string[]
	local roots = {}
	if path then
		for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			local workspace = client.config.workspace_folders
			local paths = workspace
					and vim.tbl_map(function(ws)
						return vim.uri_to_fname(ws.uri)
					end, workspace)
				or client.config.root_dir and { client.config.root_dir }
				or {}
			for _, p in ipairs(paths) do
				local r = vim.loop.fs_realpath(p) or ""
				if path:find(r, 1, true) then
					roots[#roots + 1] = r
				end
			end
		end
	end
	table.sort(roots, function(a, b)
		return #a > #b
	end)
	---@type string?
	local root = roots[1]
	if not root then
		path = path and vim.fs.dirname(path) or vim.loop.cwd()
		---@type string?
		root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
		root = root and vim.fs.dirname(root) or vim.loop.cwd()
	end
	---@cast root string
	return root
end

-- this will return a function that calls telescope.
-- cwd will defautlt to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
	local params = { builtin = builtin, opts = opts }
	return function()
		builtin = params.builtin
		opts = params.opts
		opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
		if builtin == "files" then
			if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
				opts.show_untracked = true
				builtin = "git_files"
			else
				builtin = "find_files"
			end
		end
		require("telescope.builtin")[builtin](opts)
	end
end

-- is it used anywhere?
---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
	if values then
		if vim.opt_local[option]:get() == values[1] then
			vim.opt_local[option] = values[2]
		else
			vim.opt_local[option] = values[1]
		end
		return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
	end
	vim.opt_local[option] = not vim.opt_local[option]:get()
	if not silent then
		if vim.opt_local[option]:get() then
			Util.info("Enabled " .. option, { title = "Option" })
		else
			Util.warn("Disabled " .. option, { title = "Option" })
		end
	end
end
-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
	local notifs = {}
	local function temp(...)
		table.insert(notifs, vim.F.pack_len(...))
	end

	local orig = vim.notify
	vim.notify = temp

	local timer = vim.loop.new_timer()
	local check = vim.loop.new_check()

	local replay = function()
		timer:stop()
		check:stop()
		if vim.notify == temp then
			vim.notify = orig -- put back the original notify if needed
		end
		vim.schedule(function()
			---@diagnostic disable-next-line: no-unknown
			for _, notif in ipairs(notifs) do
				vim.notify(vim.F.unpack_len(notif))
			end
		end)
	end

	-- wait till vim.notify has been replaced
	check:start(function()
		if vim.notify ~= temp then
			replay()
		end
	end)
	-- or if it took more than 500ms, then something went wrong
	timer:start(500, 0, replay)
end

local enabled = true
function M.toggle_diagnostics()
	enabled = not enabled
	if enabled then
		vim.diagnostic.enable()
		Util.info("Enabled diagnostics", { title = "Diagnostics" })
	else
		vim.diagnostic.disable()
		Util.warn("Disabled diagnostics", { title = "Diagnostics" })
	end
end

function M.deprecate(old, new)
	Util.warn(("`%s` is deprecated. Please use `%s` instead"):format(old, new), { title = "LazyVim" })
end

---used 0'th hl ns by default
---@param n string
---@param fallback string | nil
M.get_hl = function(n, fallback)
	fallback = fallback or "Normal"
	local hl = vim.api.nvim_get_hl(0, { name = n })
	-- print(vim.inspect(hl))
	if hl == nil then
		hl = vim.api.nvim_get_hl(0, { name = fallback })
		if hl == nil then
			error("no such hl group " .. n .. " or " .. fallback)
		end
	end
	if hl.link ~= nil then
		return M.get_hl(hl.link, fallback)
	end
	if hl.fg then
		hl.fg = string.format("#%06x", hl.fg)
	end
	if hl.bg then
		hl.bg = string.format("#%06x", hl.bg)
	end
	return hl
end

return M
