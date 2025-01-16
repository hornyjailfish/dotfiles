local function git_dashboard()
	local in_git = Snacks.git.get_root() ~= nil
	local cmds = {
		{
			title = "Notifications",
			cmd = "gh notify -s -a -n5",
			action = function()
				vim.ui.open("https://github.com/notifications")
			end,
			key = "n",
			icon = " ",
			height = 5,
			enabled = true,
		},
		{
			title = "Open Issues",
			cmd = "gh issue list -L 3",
			key = "i",
			action = function()
				vim.fn.jobstart("gh issue list --web", { detach = true })
			end,
			icon = " ",
			height = 7,
		},
		{
			icon = " ",
			title = "Open PRs",
			cmd = "gh pr list -L 3",
			key = "p",
			action = function()
				vim.fn.jobstart("gh pr list --web", { detach = true })
			end,
			height = 7,
		},
		{
			icon = " ",
			title = "Git Status",
			cmd = "git --no-pager diff --stat -B -M -C",
			height = 10,
		},
	}
	return vim.tbl_map(function(cmd)
		return vim.tbl_extend("force", {
			pane = 2,
			section = "terminal",
			enabled = in_git,
			padding = 0,
			ttl = 5 * 30,
			indent = 2,
		}, cmd)
	end, cmds)
end

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		-- { "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
		{ "<leader>/",       function() Snacks.picker.grep() end,                 desc = "Grep" },
		{ "<leader>:",       function() Snacks.picker.command_history() end,      desc = "Command History" },
		{ "<leader><space>", function() Snacks.picker.files() end,                desc = "Find Files" },
		-- find
		{ "<leader>fb",      function() Snacks.picker.buffers() end,              desc = "Buffers" },
		-- { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		{ "<leader>ff",      function() Snacks.picker.files() end,                desc = "Find Files" },
		{ "<leader>fg",      function() Snacks.picker.git_files() end,            desc = "Find Git Files" },
		{ "<leader>fr",      function() Snacks.picker.recent() end,               desc = "Recent" },
		-- git
		-- { "<leader>gc",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
		-- { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
		-- Grep
		{ "<leader>sb",      function() Snacks.picker.lines() end,                desc = "Buffer Lines" },
		{ "<leader>sB",      function() Snacks.picker.grep_buffers() end,         desc = "Grep Open Buffers" },
		{ "<leader>sg",      function() Snacks.picker.grep() end,                 desc = "Grep" },
		{ "<leader>sw",      function() Snacks.picker.grep_word() end,            desc = "Visual selection or word", mode = { "n", "x" } },
		-- search
		{ '<leader>s"',      function() Snacks.picker.registers() end,            desc = "Registers" },
		{ "<leader>sa",      function() Snacks.picker.autocmds() end,             desc = "Autocmds" },
		{ "<leader>sc",      function() Snacks.picker.command_history() end,      desc = "Command History" },
		{ "<leader>sc",      function() Snacks.picker.commands() end,             desc = "Commands" },
		{ "<leader>sd",      function() Snacks.picker.diagnostics() end,          desc = "Diagnostics" },
		{ "<leader>sh",      function() Snacks.picker.help() end,                 desc = "Help Pages" },
		{ "<leader>sH",      function() Snacks.picker.highlights() end,           desc = "Highlights" },
		{ "<leader>sj",      function() Snacks.picker.jumps() end,                desc = "Jumps" },
		{ "<leader>sk",      function() Snacks.picker.keymaps() end,              desc = "Keymaps" },
		{ "<leader>sl",      function() Snacks.picker.loclist() end,              desc = "Location List" },
		{ "<leader>sM",      function() Snacks.picker.man() end,                  desc = "Man Pages" },
		{ "<leader>sm",      function() Snacks.picker.marks() end,                desc = "Marks" },
		{ "<leader>sr",      function() Snacks.picker.resume() end,               desc = "Resume" },
		{ "<leader>sq",      function() Snacks.picker.qflist() end,               desc = "Quickfix List" },
		{ "<leader>sC",      function() Snacks.picker.colorschemes() end,         desc = "Colorschemes" },
		{ "<leader>qp",      function() Snacks.picker.projects() end,             desc = "Projects" },
		-- LSP
		{ "gd",              function() Snacks.picker.lsp_definitions() end,      desc = "Goto Definition" },
		{ "gr",              function() Snacks.picker.lsp_references() end,       nowait = true,                     desc = "References" },
		{ "gI",              function() Snacks.picker.lsp_implementations() end,  desc = "Goto Implementation" },
		{ "gy",              function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
		{ "<leader>ss",      function() Snacks.picker.lsp_symbols() end,          desc = "LSP Symbols" },
	},
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		bufdelete = { enabled = true },
		-- dashboard = github_dashboard,
		debug = { enabled = true },
		git = { enabled = true },
		gitbrowse = { enabled = true },
		input = { enabled = true },
		layout = { enabled = true },
		notifier = { enabled = true },
		notify = { enabled = true },
		picker = { enabled = true },
		profiler = { enabled = true },
		quickfile = { enabled = true },
		rename = { enabled = true },
		statuscolumn = {
			left = { "mark", "sign",  }, -- priority of signs on the left (high to low)
			right = { "fold", "git"}, -- priority of signs on the right (high to low)
			folds = {
				open = false, -- show open fold icons
				git_hl = true, -- use Git Signs hl for fold icons
			},
			git = {
				-- patterns to match Git signs
				patterns = { "GitSign", "MiniDiffSign" },
			},
			refresh = 50, -- refresh at most every 50ms
		},
		scope = { enabled = true },
		toggle = { enabled = true },
		words = { enabled = false },
		win = { enabled = true },
		zoom = { enabled = true },
		zen = { enabled = true },
	},
	config = function(_, opts)
		if opts.words.enabled then
			vim.keymap.set("n", "<c-n>", function() Snacks.words.jump(1, true) end,
				{ desc = "jump to next instance of the word" })
		end
		require("snacks").setup(opts)
	end
}
