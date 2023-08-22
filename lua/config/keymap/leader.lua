local logger = require("config.util.logger")
local util = require("config.util")

local cmd = vim.cmd
local fn = vim.fn

util.mapL(",", "``", {
	desc = "Press `,,` to jump back to the last cursor position.",
})
util.mapL("/", function()
	cmd.nohlsearch()
	logger.info("Highlighting cleared")
end, {
	desc = "Clear search highlighting",
})
util.mapL("e", "%", {
	desc = "Go to matching bracket",
}, {
	"n",
	"v",
})
util.mapL("g", function()
	local conf = logger.confirm({
		msg = "Are you sure you want to quit?",
		type = "Warning",
	})
	if conf == 1 then
		cmd.quitall()
	end
end, {
	desc = "[Q]uit all windows",
})
util.mapL("w", function()
	local wrap = vim.api.nvim_get_option_value("wrap", {
		scope = "local",
	})
	vim.opt_local.wrap = not wrap
end, {
	desc = "[W]rap lines",
})
util.mapL("x", function()
	fn.setfperm(fn.expand("%:p"), "rwxr-xr-x")
	logger.info({
		msg = string.format("%s made executable", fn.expand("%")),
		title = "CHMOD!",
	})
end, {
	desc = "Make file e[x]ecutable",
})
