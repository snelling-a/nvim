local Logger = require("config.util.logger")
local Util = require("config.util")

local cmd = vim.cmd
local fn = vim.fn

Util.mapL("<leader>", "``", {
	desc = "Press `,,` to jump back to the last cursor position.",
})
Util.mapL("/", function()
	cmd.nohlsearch()
	Logger.info("Highlighting cleared")
end, {
	desc = "Clear search highlighting",
})
Util.mapL("e", "%", {
	desc = "Go to matching bracket",
}, {
	"n",
	"v",
})
Util.mapL("g", function()
	local conf = Logger.confirm({
		msg = "Are you sure you want to quit?",
		type = "Warning",
	})
	if conf == 1 then
		cmd.quitall()
	end
end, {
	desc = "[Q]uit all windows",
})
Util.mapL("w", function()
	local wrap = Util.get_opt_local("wrap")

	vim.opt_local.wrap = not wrap
end, {
	desc = "[W]rap lines",
})
Util.mapL("x", function()
	fn.setfperm(fn.expand("%:p"), "rwxr-xr-x")
	Logger.info({
		msg = string.format("%s made executable", fn.expand("%")),
		title = "CHMOD!",
	})
end, {
	desc = "Make file e[x]ecutable",
})
