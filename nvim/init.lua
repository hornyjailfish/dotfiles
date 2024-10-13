local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

if jit.os == 'Windows' then
	-- FIXME: loading dll lua module looks hacky
	local dir  = vim.fs.dirname(vim.env.MYVIMRC)
	local w    = vim.fs.normalize(dir .. "\\vendor\\" .. "winreg.dll", { win = true })
	local pack = package.loadlib(w, "luaopen_winreg")
	-- INFO: this adding winreg to global packages so you can require it anythere
	if pack then
		package.preload["winreg"] = pack
	end
else
	vim.notify("This plugin is only for Windows", vim.lsp.log_levels.ERROR)
end



-- vim.loader.enable()
-- local info = vim.loader.find("winreg")

require("s.util.theme").sync()
vim.cmd.hi("clear")
require("s")
