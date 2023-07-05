local close_bad_buffers = function()
	if pcall(require, "zen-mode") then
		require("zen-mode").close()
	end

	-- vim.notify.dismiss({ silent = true, pending = true })

	local buffer_numbers = vim.api.nvim_list_bufs()

	for _, buffer_number in pairs(buffer_numbers) do
		local buffer_type = vim.api.nvim_buf_get_option(buffer_number, "buftype")

		if buffer_type == "nofile" then
			vim.api.nvim_buf_delete(buffer_number, { force = true })
		end
	end
end
-- TODO: hotkeys to save/load sessions
return {
	"echasnovski/mini.sessions",
	-- event = "VeryLazy",
	config = function()
		require("mini.sessions").setup({
			hooks = {
				pre = {
					write = function()
						close_bad_buffers()
					end,
				},
			},
			verbose = { read = false, write = true, delete = true },
		})
	end,
}
