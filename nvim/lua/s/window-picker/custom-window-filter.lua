local utils = require("s.util")

local M = {}

--- INFO: this filters table from window picker but can use everythere i want to filter stuff
M.filters = {
	-- filter using buffer options
	bo = {
		-- if the buffer type is one of following, the window will be ignored
		buftype = { "terminal", "quickfix", "nofile", "nowrite" },
		-- if the file type is one of following, the window will be ignored
		filetype = {},
	},
	-- filter using window options
	wo = {},
	-- if the file path contains one of following names, the window
	-- will be ignored
	file_path_contains = {},
	-- if the file name contains one of following names, the window will be
	-- ignored
	file_name_contains = {},
	inverse = false
}

-- filter opts but fully blocked no matter what
M.blocked = {
	bo = {
		filetype = { "notify", "snacks_notif" },
	},
	inverse = false
}

local function custom_config(self, config)
	self.blocked = config.blocked
	self.window_options = config.wo or {}
	self.buffer_options = config.bo or {}
	self.file_name_contains = config.file_name_contains or {}
	self.file_path_contains = config.file_path_contains or {}
	self.inverse = config.inverse or false
	self.include_current_win = config.include_current_win
	self.include_unfocusable_windows = config.include_unfocusable_windows
end

local function wo_filter(self, windows)
	local util = require('window-picker.util')
	if self.window_options and vim.tbl_count(self.window_options) > 0 then
		return util.tbl_filter(windows, function(winid)
			for opt_key, opt_values in pairs(self.window_options) do
				local actual_opt = vim.api.nvim_get_option_value(opt_key, { win = winid })

				local has_value = vim.tbl_contains(opt_values, actual_opt)
				if has_value then
					return has_value == self.inverse
				end
			end

			return true == not self.inverse
		end)
	else
		return windows
	end
end

local function bo_filter(self, windows)
	local util = require('window-picker.util')
	if self.buffer_options and vim.tbl_count(self.buffer_options) > 0 then
		return util.tbl_filter(windows, function(winid)
			local bufid = vim.api.nvim_win_get_buf(winid)

			for opt_key, opt_values in pairs(self.buffer_options) do
				local actual_opt = vim.api.nvim_get_option_value(opt_key, { buf = bufid })

				local has_value = vim.tbl_contains(opt_values, actual_opt)
				if has_value then
					return has_value == self.inverse
				end
			end
			return true == not self.inverse
		end)
	else
		return windows
	end
end


local function blocked(self, windows)
	local default = require("window-picker.filters.default-window-filter"):new()
	default:set_config(self.blocked or {})
	return default:filter_windows(windows) or {}
end

-- INFO: this is custom filter function using modified version of filters to inverse result
-- and utilizing default filters from stack
M.filter_func = function(windows, opts)
	local filters = require("window-picker.filters.default-window-filter"):new()
	custom_config(filters, opts)
	-- filters:set_config(opts)
	local custom_stack = {
		blocked,
		bo_filter,
		wo_filter,
		filters.filter_stack[4],
		filters.filter_stack[5]
	}
	-- INFO: default object used bu inject my filter stack
	-- stack is just array of functions that will be called in order returning bool
	-- if
	filters.filter_stack = custom_stack
	return filters:filter_windows(windows) or {}
end

M.make_rules = function(inversed)
	inversed = inversed or false
	local rules = M.filters
	rules.blocked = M.blocked
	rules.inverse = inversed
	return rules
end

return M
