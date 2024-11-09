local util = require "s.util"

local function get_tags_for_layout(layout)
	if layout == "qwerty" then
		return "FJDKSLA;CMRUEIWQP"
	elseif layout == "colemak" then
		return "TNSERIAOCHPLFUWQ;"
	end
end

return {
	-- only needed if you want to use the commands with "_with_window_picker" suffix
	-- "s1n7ax/nvim-window-picker",
	version = "v2.*",
	dev = true,
	name = "nvim-window-picker",
	dir = "~/gits/nvim-window-picker/",
	keys = {
		{
			"<leader>W",
			function()
				local filters = util.filter.filters
				filters.inverse = true
				local list = vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())
				local picked_window_id = require('window-picker').pick_window({
					-- if you want to manually filter out the windows, pass in a function that
					-- takes two parameters. You should return window ids that should be
					-- included in the selection
					-- EX:-
					-- function(window_ids, filters)
					--    -- folder the window_ids
					--    -- return only the ones you want to include
					--    return {1000, 1001}
					-- end
					filter_rules = filters,
					picker_config = {
						statusline_winbar_picker = {
							selection_display = function(char, window)
								local bufnr = vim.api.nvim_win_get_buf(window)
								local bufname = vim.api.nvim_buf_get_name(bufnr)
								local filetype, _ = vim.filetype.match({ buf = bufnr })
								local _, color = require("nvim-web-devicons").get_icon_color_by_filetype(filetype)
								if color == nil then
									color = util.hl.get("WindowPickerStatusLineNC").bg
								end
								vim.api.nvim_set_hl(0, 'Picker' .. bufnr, {
									-- fg = '#f54269',
									bg = color,
								})
								if require("s.util").has("mini.statusline") then
									return require("mini.statusline").combine_groups({
										{ hl = "Picker" .. bufnr, strings = {} },
										"%=", -- End left alignment
										{ strings = { char } },
										"%=", -- End left alignment
									})
								else
									return '%#TODO#' .. bufname .. '%=' .. char .. '%='
								end
							end,

							-- use_winbar = 'always',
						},
					},
				}) or vim.api.nvim_get_current_win()
				-- local picked_window_id = require("window-picker").pick_window({ other_win_hl_color = color })
				-- or vim.api.nvim_get_current_win()
				-- local bufnr = 2 -- Replace with the buffer number you want to check
				-- local buftype = vim.api.nvim_buf_get_option(picked_window_id, 'buftype')
				vim.api.nvim_set_current_win(picked_window_id)
				-- end
			end,
			desc = "Pick a window",
		},
		{
			"<leader>w",
			function()
				local filters = util.filter.filters
				filters.inverse = false
				local list = vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())
				local picked_window_id = require('window-picker').pick_window({
					filter_rules = filters,
					picker_config = {
						statusline_winbar_picker = {
							selection_display = function(char, window)
								local bufnr = vim.api.nvim_win_get_buf(window)
								local bufname = vim.api.nvim_buf_get_name(bufnr)
								local filetype, _ = vim.filetype.match({ buf = bufnr })
								local _, color = require("nvim-web-devicons").get_icon_color_by_filetype(filetype)
								print(color)
								if color == nil then
									color = require("s.util").hl.get("WindowPickerStatusLineNC", "DiffDelete").bg
								end
								vim.api.nvim_set_hl(0, 'Picker' .. bufnr, {
									-- fg = '#f54269',
									bg = color,
								})
								if require("s.util").has("mini.statusline") then
									return require("mini.statusline").combine_groups({
										{ hl = "Picker" .. bufnr, strings = {} },
										"%=", -- End left alignment
										{ strings = { char } },
										"%=", -- End left alignment
									})
								else
									return '%#TODO#' .. bufname .. '%=' .. char .. '%='
								end
							end,

							-- use_winbar = 'always',
						},
					},
				}) or vim.api.nvim_get_current_win()
				-- local picked_window_id = require("window-picker").pick_window({ other_win_hl_color = color })
				-- or vim.api.nvim_get_current_win()
				-- local bufnr = 2 -- Replace with the buffer number you want to check
				-- local buftype = vim.api.nvim_buf_get_option(picked_window_id, 'buftype')
				vim.api.nvim_set_current_win(picked_window_id)
				-- end
			end,
			desc = "Pick a window",
		},
	},
	config = function()
		local _, color = require("nvim-web-devicons").get_icon_color_by_filetype(vim.bo.filetype)
		require("window-picker").setup({
			autoselect_one = true,
			include_current = false,
			-- TODO: use different tags for different layouts
			selection_chars = get_tags_for_layout(vim.g.layout),
			current_win_hl_color = color,
		})
	end,
}
