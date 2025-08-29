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
	"nvim-mini/mini.sessions",
	lazy = false,
	-- event = "VeryLazy",
	opts = {
		autoread = false,
		autowrite = true,
		file = ".session.vim",
		hooks = {
			pre = {
				read = function(info)
					return
				end,
				write = function()
					close_bad_buffers()
				end,
			},
			post = {
				read = function(info) end,
			},
		},
		verbose = { read = false, write = true, delete = true },
	},
	config = function(_, opts)
		require("mini.sessions").setup(opts)
		local save_sesh = function(quit)
			quit = quit or false
			local state, err = pcall(MiniSessions.write)
			if state ~= true then
				Snacks.input.input({ prompt = "Session name", default = opts.file },
					function(name)
						MiniSessions.write(name)
						if quit then
							vim.schedule(vim.cmd.qa())
						end
					end)
			end
		end
		vim.keymap.set("n", "<leader>ql", function() MiniSessions.select() end, { desc = "List of sessions" })
		vim.keymap.set("n", "<leader>qs", function() save_sesh(false) end, { desc = "Save session" })
		vim.keymap.set("n", "<leader>qq", function()
			save_sesh(true)
		end, { desc = "Save local" })
		vim.api.nvim_create_autocmd({ "User" }, {
			-- pattern = { vim.fs.normalize(vim.env.PWD) },

			pattern = { "MiniStarterOpened" },
			once = true,
			nested = true,
			callback = function()
				local sessions = require("mini.sessions").detected
				for _, session in pairs(sessions) do
					if session.type == "local" then
						require("mini.sessions").read(session.name)
					end
				end
			end,
		})
	end,
}
