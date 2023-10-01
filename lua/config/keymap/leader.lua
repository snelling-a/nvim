local Logger = require("config.util.logger"):new("Keymaps")
local Util = require("config.util")

local cmd = vim.cmd
local map = Util.map_leader

map("<leader>", function()
	Util.feedkeys("``")
	Util.scroll_center()
end, {
	desc = "Press `,,` to jump back to the last cursor position.",
})
map("/", function()
	cmd.nohlsearch()
	Logger:info("Highlighting cleared")
end, {
	desc = "Clear search highlighting",
})
map("e", function()
	vim.cmd.normal({
		args = {
			"%",
		},
	})
end, {
	desc = "Go to matching bracket",
}, {
	"n",
	"v",
})
map("g", function()
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
map("rr", function()
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
	desc = "Exit with error code 1",
})
map("s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/I<Left><Left>]], {
	desc = "[S]earch and replace word under the cursor",
	silent = false,
})
map("w", function()
	local wrap = Util.get_opt_local("wrap")

	vim.opt_local.wrap = not wrap
end, {
	desc = "[W]rap lines",
})
map("x", function()
	local fn = vim.fn

	fn.setfperm(fn.expand("%:p"), "rwxr-xr-x")

	Logger:info({
		msg = string.format("%s made executable", fn.expand("%")),
		title = "CHMOD!",
	})
end, {
	desc = "Make file e[x]ecutable",
})
