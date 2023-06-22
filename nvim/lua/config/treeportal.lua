for id, node, metadata in vim.treesitter.query:iter_captures(tree:root(), bufnr, first, last) do
	local name = query.captures[id] -- name of the capture in the query
	-- typically useful info about the node:
	local type = node:type() -- type of the captured node
	local row1, col1, row2, col2 = node:range() -- range of the capture
	-- ... use the info here ...
end
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
