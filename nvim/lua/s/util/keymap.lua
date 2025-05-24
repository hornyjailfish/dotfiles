--- util for creating keymap strings for different layouts
--- because i use colmak and i hate c-p c-n keymap in general
local M = {}

---vim.defaulttable() with little quirks for my idea
---@param createfn? fun(key:any):any Provides the value for a missing `key`.
---@return table # Empty table with `__index` metamethod.
function keymap(createfn)
	local data = {
		a = { "M-", used = false },
		s = { "S-", used = false },
		c = { "C-", used = false },
		-- l = { "<leader>", used = false },
	}
	local function reset_used()
		for k, v in pairs(data) do
			data[k].used = false
		end
	end
	local function match_keymap(str)
		local patterns = {
			{ "alt",   "a" },
			{ "ctrl",  "c" },
			{ "shift", "s" },
			-- { "leader", "l" },
		}

		for _, pattern in ipairs(patterns) do
			for _, key in ipairs(pattern) do
				local k = pattern[2]
				if str == key then
					if data[pattern[2]].used then
						vim.notify("Duplicate key " .. pattern[1], vim.log.levels.WARN)
						return
					end
					data[k].used = true
					return data[k][1]
				end
			end
		end
		return nil
	end

	local function check_const(str)
		local pattern = {
			"down",
			"up",
			"left",
			"right",
		}
		local variants = {
			qwerty = {
				down = "j",
				up = "k",
				left = "h",
				right = "l",
			},
			colemak = {
				down = "n",
				up = "e",
				left = "m",
				right = "i",
			},
			engram = {
				down = "h",
				up = "t",
				left = ".",
				right = "s",
			},
		}

		for _, key in ipairs(pattern) do
			if str == key then
				if variants[vim.g.layout] ~= nil then
					return variants[vim.g.layout][key]
				end
			end
		end
		return nil
	end

	return setmetatable({
		str = "",
		mod = "",
		val = "",
		surround = false,
		is_leader = false,
		-- INFO: this should be last call in the chain
		-- out field not exists on table so __newindex called
		cut = function(self)
			-- print("cut", vim.inspect(self))
			self.val = self.mod .. self.str
			if self.is_leader then
				self.val = "<leader>" .. self.val
			end
			if self.surround then
				self.val = "<" .. self.val .. ">"
			end
			return self.out
		end
	}, {
		__newindex = function(t, k, v)
			print("Finalizing string:", t.val, vim.inspect(k))
			if t.surround then
				t.val = "<" .. t.mod .. t.str ">"
			else
				t.val = t.mod .. t.str
			end
			if t.is_leader then
				t.val = "<leader>" .. t.mod .. t.str
			else
			end
		end,
		__index = function(tbl, key)
			if type(key) == "string" then
				key = key:lower()
				if key == "out" then
					local out = tbl.val
					tbl.val = ""
					tbl.str = ""
					tbl.mod = ""
					tbl.surround = false
					tbl.is_leader = false
					reset_used()
					return out
				end
				if key == "leader" or key == "l" then
					tbl.is_leader = true
					return tbl
				end
				local x = match_keymap(key)
				if x == nil then
					local const = check_const(key)
					if const ~= nil then
						tbl.str = const
						return tbl:cut()
					end
					vim.notify("Keymap is not valid? last index: " .. key, vim.log.levels.WARN)
					return tbl
				end
				rawset(tbl, "mod", tbl.mod .. x)
			end


			-- TODO: allow combo keymaps like <C-w><C-w>
			-- need to add surroundings to tbl.str
			--  and split leader from it
			return tbl
		end,
		__call = function(tbl, key, surround)
			if type(key) ~= "string" then
				vim.notify("keymap should be string", vim.log.levels.ERROR)
				return
			end

			if string.len(key) == 0 then
				vim.notify("keymap string is empty?", vim.log.levels.ERROR)
			end

			if surround then
				tbl.surround = true
			end

			key = key:lower()
			if string.len(key) > 1 then
				local const = check_const(key)
				if const ~= nil then
					tbl.str = const
					return tbl:cut()
				end
				vim.notify("string more then one letter!", vim.log.levels.WARN)
				return key
			else
				tbl.str = key
			end


			reset_used()
			return tbl:cut()
		end,
	})
end

M.map = keymap()


return M
