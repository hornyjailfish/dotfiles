local M = {}

---@type Wezterm
local wezterm = require("wezterm")

local ws = require("workspace.dir").workspaces
M.ws = ws
return M
