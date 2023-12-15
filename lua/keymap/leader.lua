local Keymap = require("keymap.util")

local cmd = vim.cmd

local M = {}

---@type Leader
function M.map_leader(lhs, rhs, opts, mode)
	Keymap.map(mode or "n", ("<leader>%s"):format(lhs), rhs, opts)
end

local leader = M.map_leader

leader("<leader>", function()
	Keymap.feedkeys("``")
	require("keymap.center_actions").scroll()
end, { desc = "Press `,,` to jump back to the last cursor position." })

leader("/", function()
	cmd.nohlsearch()
	cmd.diffupdate()
	cmd.syntax("sync fromstart")
	cmd.redraw({ bang = true })
	Keymap.Logger:info("Highlighting cleared")
end, { desc = "Clear and redraw the screen" })

leader("e", function()
	vim.cmd.normal({ args = { "%" } })
end, { desc = "Go to matching bracket" }, { "n", "v" })

leader("g", function()
	local conf = Keymap.Logger:confirm({
		msg = "Are you sure you want to quit?",
		type = "Warning",
	})
	if conf == 1 then
		cmd.quitall()
	end
end, { desc = "[Q]uit all windows" })

leader("K", function()
	vim.cmd.normal({ args = { "K" }, bang = true })
end, { desc = "Keywordprg" })

leader("l", vim.cmd.lopen, { desc = "Open [l]ocation list" })

leader("rr", function()
	vim.api.nvim_exec2(
		[[
        wall!
        cquit
    ]],
		{ output = false }
	)
end, { desc = "Exit with error code 1" })

leader("rG", function()
	vim.cmd.lgrep({
		args = { "<cword>", "%" },
		mods = { silent = true },
	})
	vim.cmd.lopen()
end, { desc = "[r]ip[g]rep current file for word under the cursor" })
leader("rg", function()
	vim.cmd.grep({
		args = { "<cword>" },
		bang = true,
		mods = { silent = true },
	})
	vim.cmd.copen()
end, { desc = "[r]ip[g]rep for word under the cursor" })

leader("s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/I<Left><Left>]], {
	desc = "[S]earch and replace word under the cursor",
	silent = false,
})

leader("w", function()
	require("util").toggle("wrap")
end, { desc = "Toggle line [w]rap" })

leader("q", vim.cmd.copen, { desc = "Open [q]uickfix list" })

leader("x", function()
	local fn = vim.fn

	fn.setfperm(fn.expand("%:p"), "rwxr-xr-x")

	Keymap.Logger:info({
		msg = ("%s made executable"):format(fn.expand("%")),
		title = "CHMOD!",
	})
end, { desc = "Make file e[x]ecutable" })

return M
