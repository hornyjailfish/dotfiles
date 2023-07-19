require("config")
return {
  {
    "rktjmp/shipwright.nvim",
  },
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua",
      config = function ()
        vim.g.sqlite_clib_path = vim.fs.normalize("~/scoop/apps/sqlite/current/sqlite3.dll")
      end
    },
    lazy = true,
    opts = {
      colors = {
        bg = "SignColumn",
      },
    },
    config = function (_,opts)
      require("NeoComposer").setup(opts)
      -- local bg = vim.api.nvim_get_hl(0,{})["SignColumn"].bg
      -- bg = string.format("#%x",bg)
      -- -- print(bg)
      -- vim.api.nvim_set_hl(0, "RecordingSymbol", {bg = bg })
    end,
  },
	{
		-- dont like it because i cant preview diff while go through list
		"mbbill/undotree",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
		},
		config = function()
			vim.g.undotree_WindowLayout = 4
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
	},
	{
		-- daily notes naming need fixes
		"epwalsh/obsidian.nvim",
		event = { "BufReadPre " .. vim.fs.normalize("~/mind/**.md") },
		opts = {
			dir = "~/mind",
			daily_notes = {
				folder = "daily",
			},
			completion = {
				nvim_cmp = true,
			},
			templates = {
				subdir = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},
		},
	},
}
