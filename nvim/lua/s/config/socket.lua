-- kanata kbd layout string for status line and tcp msg to switch layer
--  kanata -c ... -p port to work with
local port = 42069
local Kanata = {
	socket = vim.loop.new_tcp(),
	result = "",
	msg = nil,
}
-- local function not_empty(m)
-- 	if m == "" or m ~= nil then
-- 		return false
-- 	else
-- 		return true
-- 	end
-- end

function Kanata:connect(err)
	if self.socket then
		self.socket:connect("127.0.0.1", port, self:callback(err))
		assert(not err, "cant connect")
		if self.result == "" then
			self.result = ""
		end
	else
		self.socket = vim.loop.new_tcp()
		self:connect(err)
	end
end

function Kanata:close()
	self.socket:close(function()
		self.result = ""
		self.msg = nil
	end)
	self.socket = nil
end

function Kanata:callback(err)
	assert(not err, err)
	if vim.loop.is_readable(self.socket) then
		self.socket:read_start(function(err, chunk)
			if err then
				-- handle read error
				print(err)
				self:close()
				self:connect()
			elseif chunk then
				-- handle data
				local json = vim.json.decode(chunk)
				if json then
					self.result = json.LayerChange.new
				end
			else
				-- handle disconnect
				self.socket:close()
				self.msg = nil
				self.result = ""
			end
		end)
	end
	if vim.loop.is_writable(self.socket) and self.msg then
		self:send()
	end
end

function Kanata:send()
	local f = ""
	if self.socket and vim.loop.is_writable(self.socket) then
		f = '{"ChangeLayer":{"new":"' .. self.msg .. '"}}'
		self.result = self.msg
		self.socket:write(f)
		self.msg = nil
	end
end

-- Kanata:connect()

return Kanata
