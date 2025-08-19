return {
	["add deps"] = {
		desc = "add dependency tasks",
		condition = function(task)
			-- local tasks = require("overseer.task_list").list_tasks({ unique = true, name_not = true, name = task.name })
			-- return #tasks>1
			return true
		end,
		run = function(task)
			local tasks = require("overseer.task_list").list_tasks({ name_not = true, name = task.name })
			if (#tasks > 0) then
				vim.ui.select(tasks, {
						prompt = "Select dependency task",
						format_item = function(item)
							return item.name
						end
					},
					function(choice)
						if (choice) then
							task:add_component({
								"dependencies",
								task_names = {
									choice.name
								},
								sequential = true,
							})
						end
					end)
				task:restart()
			end
		end,
	},
	edit = false,
}
