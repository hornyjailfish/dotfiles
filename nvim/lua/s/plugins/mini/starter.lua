local update_startuptime = function()
	local startuptime = require("lazy").stats().startuptime
	local loaded = require("lazy").stats().loaded
	local total = require("lazy").stats().count
	--vim.cmd.lua("MiniStarter.refresh()")
	return string.format("Startuptime: %.2f ms for %i/%i plugins", startuptime, loaded, total)
end

function display_startuptime()
	local startuptime_text = update_startuptime()
	-- vim.api.nvim_echo({ { startuptime_text, "Normal" } }, true, {})
	return startuptime_text
end
-- vim.cmd.autocmd("User LazyVimStarted let g:statuptime = luaeval('display_startuptime()')")

return {
	"echasnovski/mini.starter",
	-- event = "VeryLazy",
	enabled = true,
	config = function()
		local my_items = {
			{ name = "Mason", action = [[Mason]], section = "Builtin actions" },
			{ name = "Lazy",  action = [[Lazy]],  section = "Builtin actions" },
		}

		require("mini.starter").setup({
			items = {
				require("mini.starter").sections.sessions(10, true),
				require("mini.starter").sections.recent_files(5, true, false),
				my_items,
				require("mini.starter").sections.builtin_actions(),
			},
			header = "",
			footer = function()
				-- vim.cmd.autocmd("User LazyVimStarted lua MiniStarter.refresh()")
				-- return display_startuptime()
				return ""
			end,
		})
	end,
}
