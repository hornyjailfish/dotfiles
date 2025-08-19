return {
	["dependency"] = {
		desc = "add dependency tasks",
		priority = 50,
		condition = function(task)
			return task.bulider == nil
			-- local tasks = require("overseer.task_list").list_tasks({ unique = true, name_not = true, name = task.name })
			-- return #tasks>1
			-- return true
		end,
		run = function(task)
			-- local tasks = require("overseer.task_list").list_tasks({ name_not = true, name = task.name })
			require("overseer.commands").preload_cache(nil, function(templates, _)
				templates = vim.tbl_filter(function(tmpl)
					return (not tmpl.hide) or tmpl.nam == task.name
				end, templates)
				if (#templates > 0) then
					vim.ui.select(templates, {
							prompt = "Select dependency task",
							format_item = function(item)
								return item.name
							end
						},
						function(choice)
							if (choice) then
								vim.notify("Adding dependency task: " .. choice.name)
								task:add_component({
									"dependencies",
									task_names = {
										choice.name,
									},
									sequential = true,
								})
								task:restart()
							end
						end)
				end
			end)
		end,
	},
	edit = false,
}
