-- utils from LazyVim distribution
-- at start i just clone it and rework everything besides lsp setups and default configs for telescope

local Util = require("lazy.core.util")

local M = {}

M.filter = {}
--- INFO: this filters table from window picker but can use everythere i want to filter stuff
M.filter.filters = {
	-- filter using buffer options
	bo = {
		-- if the file type is one of following, the window will be ignored
		filetype = { "neo-tree", "neo-tree-popup", "undotree", "diff", "notify", "nofile" },
		-- if the buffer type is one of following, the window will be ignored
		buftype = { "terminal", "quickfix", "telescope", "nofile" },
	},
	-- filter using window options
	wo = {},
	-- if the file path contains one of following names, the window
	-- will be ignored
	file_path_contains = {},
	-- if the file name contains one of following names, the window will be
	-- ignored
	file_name_contains = {},
}

M.filter.test = {
	bo = {},
	wo = {},
	file_path_contains = {  },
	file_name_contains = { "init.lua" },

}

local function cmp_bo(bufnr)
	local res
	for k, v in pairs(M.filter.filters.bo) do
		res = vim.list_contains(v, vim.bo[bufnr][k])
		if res then break end
	end
	return res
end

local function cmp_wo(bufnr)
	local res
	for k, v in pairs(M.filter.filters.wo) do
		res = vim.list_contains(v, vim.wo[bufnr][k])
		if res then break end
	end
	return res
end

--- NOTE: this modifies input array so no aux list is created
function filter(array, predicate)
	local index = 1
	for i = 1, #array do
		if predicate(array[i]) then
			array[index] = array[i]
			index = index + 1
		end
	end
	-- Clear the rest of the array
	for i = index, #array do
		array[i] = nil
	end
end

M.filter.bo = function(win)
	if type(win) == "table" then
		-- TODO: filter single
		if vim.tbl_isempty(win) then
			return
		end
		filter(win, function(id)
			local bufnr = vim.api.nvim_win_get_buf(id)
			return vim.tbl_isempty(M.filter.filters.bo)
			    or not cmp_bo(bufnr)
		end)
		return win
	end
	if type(win) == "number" then
		local bufnr = vim.api.nvim_win_get_buf(win)
		return vim.tbl_isempty(M.filter.filters.bo) or vim.tbl_contains(M.filter.filters.bo, vim.bo[bufnr])
	end

	return false
end

local plugins = function()
	local lazy = require("lazy")
	local plugins = {}
	local list = lazy.plugins()
	for key, value in pairs(list) do
		if value.name then
			table.insert(plugins, value.name)
		end
	end
	return plugins
end


M.reload = function(pkgs)
	local lazy = require("lazy")
	pkgs = pkgs or plugins()
	vim.ui.select(pkgs, { prompt = "Select plugin to reload" }, function(choice)
		lazy.reload({ plugins = { choice } })
	end)
end


M.hl = require("s.util.hl")
M.keymaps = require("s.util.keymap")
-- shorthand for using global var
M.keymap = M.keymaps.layout(vim.g.layout or "qwerty").keymap

M.root_patterns = { ".git", "lua", "pyproject.toml", "Cargo.toml", "package.json", "tsconfig.json", "Makefile" }


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
		vim.diagnostic.enable(false)
		Util.warn("Disabled diagnostics", { title = "Diagnostics" })
	end
end

function M.deprecate(old, new)
	Util.warn(("`%s` is deprecated. Please use `%s` instead"):format(old, new), { title = "LazyVim" })
end

return M
