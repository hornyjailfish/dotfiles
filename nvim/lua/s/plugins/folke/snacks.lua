local github_dashboard = {
	enabled = true,
	sections = {
		-- { section = "header" },
		-- { section = "keys",  gap = 1, padding = 1 },
		-- {
		-- 	pane = 2,
		-- 	icon = " ",
		-- 	desc = "Browse Repo",
		-- 	padding = 1,
		-- 	key = "b",
		-- 	action = function()
		-- 		Snacks.gitbrowse()
		-- 	end,
		-- },
		function()
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
					pane = 1,
					section = "terminal",
					enabled = in_git,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				}, cmd)
			end, cmds)
		end,
		{ section = "startup" },
	},
}

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		bufdelete = { enabled = true },
		dashboard = github_dashboard,
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
		statuscolumn = { enabled = true },
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
