local Logger = require("config.util.logger"):new("Keymaps")
local Util = require("config.util")

local cmd = vim.cmd

Util.mapL("<leader>", function()
	Util.feedkeys("``")
	Util.scroll_center()
end, {
	desc = "Press `,,` to jump back to the last cursor position.",
})
Util.mapL("/", function()
	cmd.nohlsearch()
	Logger:info("Highlighting cleared")
end, {
	desc = "Clear search highlighting",
})
Util.mapL("e", function()
	vim.cmd.normal({
		args = {
			"%",
		},
		-- bang = true,
	})
end, {
	desc = "Go to matching bracket",
}, {
	"n",
	"v",
})
Util.mapL("g", function()
	local conf = Logger:confirm({
		msg = "Are you sure you want to quit?",
		type = "Warning",
	})
	if conf == 1 then
		cmd.quitall()
	end
end, {
	desc = "[Q]uit all windows",
})
Util.mapL("rr", function()
	vim.api.nvim_exec2(
		[[
        wall!
        cquit
    ]],
		{
			output = false,
		}
	)
end, {
	noremap = true,
	silent = true,
	desc = "Exit with error code 1",
})
Util.mapL("w", function()
	local wrap = Util.get_opt_local("wrap")

	vim.opt_local.wrap = not wrap
end, {
	desc = "[W]rap lines",
})
Util.mapL("x", function()
	local fn = vim.fn

	fn.setfperm(fn.expand("%:p"), "rwxr-xr-x")

	Logger:info({
		msg = string.format("%s made executable", fn.expand("%")),
		title = "CHMOD!",
	})
end, {
	desc = "Make file e[x]ecutable",
})
