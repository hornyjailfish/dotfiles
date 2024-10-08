local function modules_loaded(...)
	local module_names = { ... }
	local loaded_count = 0
	for _, module_name in ipairs(module_names) do
		if _G[module_name] ~= nil then
			loaded_count = loaded_count + 1
		end
	end
	return loaded_count == #module_names
end

local all_loaded = modules_loaded("portal", "trailblazer", "treesitter")

if all_loaded then
	return
end

local function get_trails()
	-- local portal = require("portal")
	-- local Iterator = require("portal.iterator")

	local trailblazer = require("trailblazer.trails")
	local helpers = require("trailblazer.helpers")

	trailblazer.common.remove_duplicate_pos_trail_marks()
	-- local old_sorting = require("trailblazer.trails.config").custom.current_trail_mark_stack_sort_mode
	-- require("trailblazer").set_trail_mark_stack_sort_mode("chron_dsc", false)

	local trail_marks = trailblazer.common.get_trail_mark_stack_subset_for_buf()

	-- Transform the trail marks into a custom location list
	---@diagnostic disable-next-line: param-type-mismatch
	if next(trail_marks) == nil then
		print("Trails not found")
		return
	end

	-- print(vim.inspect(trail_marks))

	local custom_location_list = {}
	---@diagnostic disable-next-line: param-type-mismatch
	for _, trail_mark in ipairs(trail_marks) do
		-- print(vim.inspect(trail_mark))

		table.insert(custom_location_list, {
			bufnr = trail_mark.buf,
			filename = helpers.buf_get_absolute_file_path(trail_mark.buf),
			lnum = trail_mark.pos[1],
			col = trail_mark.pos[2],
			-- col = trail_mark.pos[2] + 1,
			text = vim.api.nvim_buf_get_lines(trail_mark.buf, trail_mark.pos[1] - 1, trail_mark.pos[1], false)[1],
			id = trail_mark.mark_id,
			window = trail_mark.window,
		})
	end
	-- require("trailblazer").set_trail_mark_stack_sort_mode(old_sorting, false)

	trailblazer.common.update_all_trail_mark_positions()
	return custom_location_list
	-- print(vim.inspect(custom_location_list))
	-- -- Create a custom iterator and query
	-- local custom_iter = Iterator:new(custom_location_list)
	-- local custom_query = { source = custom_iter }

	-- portal.tunnel(custom_query)
	-- Use the custom query with portal#tunnel
	-- else
	-- 	print("Not all specified plugins are loaded")
	-- end
end

function Portal_trails()
	local trails_data = get_trails()
	if trails_data == nil then
		return
	end

	local trailblazer = require("trailblazer.trails")
	trailblazer.common.reregister_trail_marks(false)
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
			type = "trails",
			buffer = v.bufnr,
			cursor = { row = v.lnum, col = v.col },
			callback = function(content)
				-- if require("trailblazer.trails").common.get_marks_for_trail_mark_index(v.bufnr, v.id, true) then
				-- local m = require("trailblazer.trails").common.get_marks_for_trail_mark_index(v.bufnr, v.id, true)
				vim.api.nvim_win_set_buf(0, content.buffer)
				vim.api.nvim_win_set_cursor(0, { content.cursor.row, content.cursor.col })
				trailblazer.common.delete_trail_mark_at_pos(v.window, v.bufnr, { v.lnum, v.col })
				-- end

				trailblazer.common.update_all_trail_mark_positions()

				-- FIXME: hilight groups weirdo ...at least it works
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

function Portal_diag()
	local data = vim.diagnostic.get()

	if vim.tbl_isempty(data) then
		print("No diagnostics found")
		return
	end

	table.sort(data, function(a, b)
		if a.bufnr == b.bufnr then
			return a.severity < b.severity
		end
		return a.bufnr < b.bufnr
	end)

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
	local list = Iterator:new(data)
	list = list:map(function(v)
		return Content:new({
			type = vim.diagnostic.config().signs.text[v.severity].. " " .. v.message,
			buffer = v.bufnr,
			cursor = { row = v.lnum + 1, col = v.col },
			extra = {
				severity = v.severity,
				message = v.message,
				source = v.source
			},
			callback = function(content)
				vim.api.nvim_win_set_buf(0, content.buffer)
				vim.api.nvim_win_set_cursor(0, { content.cursor.row, content.cursor.col })
			end,
		})
	end)
	list = list:filter(function(v)
		return vim.api.nvim_buf_is_valid(v.buffer)
	end)

	local f = list
		--- @param acc Portal.Content[]
		--- @param val Portal.Content
		--- @param i number
		--- @return Portal.Iterator
		:reduce(function(acc, val, i)
			if i == 1 then
				acc[i] = val
				return acc
			end

			local flag = false
			for j, v in ipairs(acc) do
				if v.buffer == val.buffer and v.cursor.row == val.cursor.row then
					flag = true
					if v.extra.severity > val.extra.severity then
						acc[j] = val
					end
				end
			end
		local a
		local b
			if not flag then
				acc[i]=val
			end
			flag = false
			return acc
		end, {})

	local custom_query = {
		source = Iterator:new(f),
		-- slots =
		-- 	function(v)
		-- 		local diag = vim.diagnostic.get()
		-- 		local res = table
		-- 		for i, d in ipairs(diag) do
		-- 				res:insert(i,(v.buffer == d.bufnr and v.cursor.row ~= d.lnum+1) or v.buffer ~= d.bufnr)
		-- 		end
		-- 		return res
		-- 	end,
	}
	-- local custom_query = portal.query.new(search_predicate, search_opts)
	-- require("portal.builtin").quickfix.tunnel()
	-- local found = portal.search(custom_query)
	portal.tunnel(custom_query,{highlight_opts = {hl_group = "Search"}})
end

vim.cmd("command! Portrails lua Portal_trails()")
vim.cmd("command! Portaldiag lua Portal_diag()")
vim.keymap.set("n", "<A-g>", function()
	Portal_trails()
end, {})
vim.keymap.set("n", "<A-d>", function()
	Portal_diag()
end, {})
