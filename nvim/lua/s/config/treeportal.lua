local function get_node()
	-- Get the current syntax tree
	local parser = vim.treesitter.get_parser()
	local tree = parser:parse()[1]

	-- Get the root node of the syntax tree
	local root = tree:root()

	-- Get a specific node in the syntax tree (e.g., the first function call)
	local node = vim.treesitter.get_node()
	local t = {}

	-- Get the start position of the node
	if node == nil then
		print("node is nil")
		return
	end

	local end_row, end_col = node:end_()
	table.insert(t, { row = end_row + 1, col = end_col })
	local start_row, start_col, _ = node:start()
	table.insert(t, { row = start_row + 1, col = start_col })

	if node:prev_sibling() ~= nil then
		local prev_row, prev_col = node:prev_named_sibling():start()
		table.insert(t, { row = prev_row + 1, col = prev_col })
	end
	if node:next_sibling() ~= nil then
		local next_row, next_col = node:next_named_sibling():start()
		table.insert(t, { row = next_row + 1, col = next_col })
	end
	local custom_location_list = {}
	for _, e in ipairs(t) do
		table.insert(custom_location_list, {
			bufnr = 0,
			filename = vim.api.nvim_buf_get_name(0),
			lnum = e.row,
			col = e.col,
			-- col = trail_mark.pos[2] + 1,
			text = vim.api.nvim_buf_get_lines(0, e.row, e.col, false)[1],
			-- id = vim.api.nvim_get_current_win,
			window = vim.api.nvim_get_current_win(),
		})
	end
	return custom_location_list
end

function Portal_tree()
	local trails_data = get_node()
	if trails_data == nil then
		return
	end
	-- print(vim.inspect(trails_data))
	local portal = require("portal")
	-- local search_predicate = function(value)
	-- 	for _, trail in ipairs(trails_data) do
	-- 		if value.filename == trail.filename and value.lnum == trail.lnum then
	-- 			return true
	-- 		end
	-- 	end
	-- return false
	-- end
	-- local search_opts = {}
	local Iterator = require("portal.iterator")
	local Content = require("portal.content")
	local list = Iterator:new(trails_data)
	list = list:map(function(v)
		return Content:new({
			type = "treesitter",
			buffer = v.bufnr,
			cursor = { row = v.lnum, col = v.col },
			callback = function(content)
				vim.api.nvim_win_set_buf(0, content.buffer)
				vim.api.nvim_win_set_cursor(0, { content.cursor.row, content.cursor.col })
				-- end
			end,
		})
	end)
	list = list:filter(function(v)
		return vim.api.nvim_buf_is_valid(v.buffer)
	end)

	-- print(vim.inspect(list))
	local custom_query = { source = list }
	-- local custom_query = portal.query.new(search_predicate, search_opts)
	-- require("portal.builtin").quickfix.tunnel()
	-- local found = portal.search(custom_query)
	-- print(vim.inspect(found))
	portal.tunnel(custom_query)
end
vim.cmd("command! Portree lua Portal_tree()")

vim.keymap.set("n", "<A-t>", function()
	Portal_tree()
end, {})
