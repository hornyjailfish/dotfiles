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
		l = { "<leader>", used = false },
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
		}

		-- print("in", str)

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

	-- local v = ""
	-- createfn = createfn or function(key)
	-- 	print("cb", key, v)
	-- 	return keymap()
	-- end
	return setmetatable({
		str = "",
		mod = "",
		val = "",
		surround = false,
		leader = false,
		is_leader = false,
		-- INFO: this should be last call in the chain
		-- out field not exists on table so __newindex called
		cut = function(self)
			-- print("cut",vim.inspect(self))
			self.out = self.str
			return self.out
		end
	}, {
		__newindex = function(t, k, v)
			print("Finalizing string:", t.val, v)
			if t.is_leader then
				t.val = "<leader>" .. t.val .. v
			else
				if t.surround then
						t.val = "<"..t.val .. t.mod .. v..">"
					else
						t.val = t.val .. t.mod .. v
					end
			end
		end,
		__index = function(tbl, key)
			if type(key) == "string" then
				key = key:lower()
				if key == "leader" or key == "l" then
					tbl.is_leader = true
					-- print("idx lead", tbl.str)
					if tbl.leader then
						print("Double leader?")
						tbl.leader = false
					end
					tbl.leader = true
					return tbl
				end
				if key == "out" then
					local out = tbl.val
					tbl.val = ""
					tbl.str = ""
					tbl.mod = ""
					return out
					-- return tbl
				end
				-- print("index", key, "creating map...")
				-- tbl[key] = function(self)
				local x = match_keymap(key)
				if x == nil then
					vim.notify("Keymap is not valid? last index: " .. key, vim.log.levels.WARN)
					return tbl
				end
				rawset(tbl, "mod", tbl.mod .. x)
				-- return self
			end
			-- end


			-- TODO: allow combo keymaps like <C-w><C-w>
			-- need to add surroundings to tbl.str
			--  and split leader from it
			return tbl
			-- return rawset(tbl, key, createfn(key))
		end,
		__call = function(tbl, key, surround)
			if type(key) ~= "string" then
				vim.notify("keymap should be string", vim.log.levels.ERROR)
				return
			end

			if string.len(key) == 0 then
				vim.notify("keymap string is empty?", vim.log.levels.ERROR)
			end

			key = key:lower()
			if string.len(key) > 1 then
				vim.notify("if string more then one letter! Please consider using leader()", vim.log.levels.WARN)
				-- tbl.str = "<leader>" .. tbl.str .. key
				tbl.str = tbl.str .. key
			else
				-- tbl.str = tbl.str .. key
				tbl.str = key
			end
			-- FIXME: allow multiple calls for chain maps like <C-w><C-w> should return full table before cut
			if tbl.leader then
				-- print("call lead!", tbl.is_leader, tbl.str, tbl.mod)
				tbl.leader = false
				tbl.is_leader = true
				tbl.val = tbl.val .. tbl.str
				return tbl
			end

			if surround then
					tbl.surround = true
			-- 		print("sur", tbl.mod, tbl.str,tbl.val,key)
			-- 	if type(surround) == "table" then
			-- 		tbl.str = string.format("%s%s%s", surround[1], tbl.str, surround[2])
			-- 	else
			-- 		tbl.str = string.format("<%s>", tbl.str)
			-- 	end
			end


			if tbl.is_leader then
				tbl.str = "<" .. tbl.mod .. tbl.str .. ">"
			end

			reset_used()
			return tbl:cut()
		end,
	})
end

local map = keymap()
-- print(map.a.s.c("x", true))
-- print(vim.inspect(map.l("c").c("c").c"c"))


M.map = map

-- local _ = {}
-- function _.chain(value)
-- 	local tbl = {
-- 		_value = value,
-- 		value = function(self)
-- 			return self._value
-- 		end
-- 	}
-- 	-- merge methods in tbl
-- 	for k, v in pairs(_) do
-- 		-- if type(v) == "function" then
-- 		tbl[k] = function(self, ...)
-- 			local result = v(self._value, ...)
-- 			if result ~= self._value then
-- 				self._value = result
-- 			end
-- 			return self
-- 			-- end
-- 		end
-- 	end
--
-- 	return tbl
-- end
--
-- ---add surroundings to a string '< >' by default
-- ---@param symbol string[]
-- ---@return string
-- function _:surround(symbol)
-- 	local symbol = symbol or { "<", ">" }
-- 	return string.format("%s%s%s", symbol[1], self, symbol[2])
-- end
--
-- function _:ctrl()
-- 	return string.format("C-%s", self)
-- end
--
-- function _:shift()
-- 	return string.format("S-%s", self)
-- end
--
-- -- A or M?
-- function _:alt()
-- 	return string.format("M-%s", self)
-- end
--
-- local _k = { a, c, s, value = _ }
-- _k.new = function(value)
-- 	value:chain(value)
-- end
-- setmetatable(_k, {
-- 	__index =
-- 		function(t, k)
-- 			if k == 'a' then
-- 				return new(""):alt()
-- 			end
-- 			if k == 'c' then
-- 				return new(t._value):ctrl()
-- 			end
-- 			if k == 's' then
-- 				return _:shift()
-- 			end
-- 		end
-- })
--
-- local test = _k
--
-- TODO: revork syntax?
-- I hate c-p c-n keymap so i create this to use it with colemak/qwerty depending on vim.g.layout
---@param name string
function M.layout(name)
	local function add_surround(str)
		return "<" .. str .. ">"
	end
	local function modifier(mod, str)
		local mod_map = {
			mod.ctrl and "C-" or "",
			mod.shift and "S-" or "",
			mod.alt and "A-" or "",
			str,
		}
		return table.concat(mod_map, "")
	end
	---@param str string
	---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
	---@param sur boolean
	local function create_mapstr(str, mod, sur)
		local str = str
		local mod = mod or {}
		if next(mod) == nil then
			return sur and add_surround(str) or str
		end
		str = modifier(mod, str)
		return sur and add_surround(str) or str
	end

	if name == "qwerty" then
		return {
			keymap = {
				down = function(sur)
					return create_mapstr("j", mod, sur)
				end,
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				up = function(mod, sur)
					return create_mapstr("k", mod, sur)
				end,
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				left = function(mod, sur)
					return create_mapstr("h", mod, sur)
				end,
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				right = function(mod, sur)
					return create_mapstr("l", mod, sur)
				end,
			},
		}
		-- return {
		-- 	keymap = {
		-- 		---@param mod {shift:boolean,ctrl:boolean,alt:boolean} modifiers
		-- 		---@param sur boolean surround with < >
		-- 		down = function(mod, sur)
		-- 			return create_mapstr("j", mod, sur)
		-- 		end,
		-- 		---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
		-- 		---@param sur boolean
		-- 		up = function(mod, sur)
		-- 			return create_mapstr("k", mod, sur)
		-- 		end,
		-- 		---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
		-- 		---@param sur boolean
		-- 		left = function(mod, sur)
		-- 			return create_mapstr("h", mod, sur)
		-- 		end,
		-- 		---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
		-- 		---@param sur boolean
		-- 		right = function(mod, sur)
		-- 			return create_mapstr("l", mod, sur)
		-- 		end,
		-- 	},
		-- }
	elseif name == "colemak" then
		return {
			keymap = {
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				down = function(mod, sur)
					return create_mapstr("n", mod, sur)
				end,
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				up = function(mod, sur)
					return create_mapstr("e", mod, sur)
				end,
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				left = function(mod, sur)
					return create_mapstr("m", mod, sur)
				end,
				---@param mod {shift:boolean,ctrl:boolean,alt:boolean}
				---@param sur boolean
				right = function(mod, sur)
					return create_mapstr("i", mod, sur)
				end,
			},
		}
	end
end

return M
