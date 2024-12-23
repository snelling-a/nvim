local Maps = require("user.keymap.maps")

Maps.create_breakpoint(")")
Maps.create_breakpoint(",")
Maps.create_breakpoint(".")
Maps.create_breakpoint(";")
Maps.create_breakpoint(">")
Maps.create_breakpoint("]")
Maps.create_breakpoint("}")

Maps.indent("<")
Maps.indent(">")

Maps.scroll_center(")")
Maps.scroll_center(")")
Maps.scroll_center("<C-d")
Maps.scroll_center("<C-u")
Maps.scroll_center("G")
Maps.scroll_center("zx")
Maps.scroll_center("{")
Maps.scroll_center("}")

Maps.vertical_move("j")
Maps.vertical_move("k")

Maps.wild("n")
Maps.wild("p")

vim.keymap.set(
	{ "n" },
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/I<Left><Left>]],
	{ desc = "[S]earch and replace word under the cursor", silent = false }
)

vim.keymap.set({ "v" }, "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set({ "n" }, "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set({ "i" }, "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set({ "v" }, "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
vim.keymap.set({ "n" }, "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set({ "i" }, "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })

vim.keymap.set({ "n" }, "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set({ "n" }, "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set({ "n" }, "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
vim.keymap.set({ "n" }, "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })

vim.keymap.set({ "n" }, "<C-z>", "<nop>", { desc = "Disable `:stop` keymap" })

vim.keymap.set({ "n" }, "<Esc><Esc>", function()
	vim.cmd.nohlsearch()
	vim.cmd.diffupdate()
	vim.cmd.normal({ args = { "<C-l>" }, bang = true })
end, { desc = "Redraw / Clear hlsearch / Diff Update" })

vim.keymap.set({ "n" }, "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

vim.keymap.set({ "n", "v" }, "<leader>e", function()
	vim.cmd.normal({ args = { "%" } })
end, { desc = "Go to matching bracket" })

vim.keymap.set({ "n" }, "<leader>x", function()
	local fname = vim.fn.expand("%:p")
	local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]

	if not first_line or not first_line:match("^#!") then
		local okay, choice =
			pcall(vim.fn.confirm, ("No shebang found\nmake %q executable?"):format(fname), "&Yes\n&No\n&Cancel")
		if not okay or choice ~= 1 then
			vim.notify(("Did not make %q executable"):format(fname), vim.log.levels.WARN)
			return
		end
	end

	local okay, success = pcall(vim.fn.setfperm, fname, "rwxr-xr--")
	if not okay or success == 0 then
		vim.notify(("Failed to make %q executable"):format(fname), vim.log.levels.ERROR)
		return
	end

	vim.notify(fname .. " is now executable")
end, { desc = "Make file e[x]ecutable" })

vim.keymap.set({ "n" }, "<leader>l", function()
	local ok = pcall(vim.cmd.lopen)
	if not ok then
		vim.notify("No location list to open")
		return
	end
end, { desc = "Location List" })
vim.keymap.set({ "n" }, "<leader>q", function()
	if vim.tbl_isempty(vim.fn.getqflist()) then
		vim.notify("No quickfix list to open")
		return
	end

	vim.cmd.copen()
end, { desc = "Quickfix List" })

vim.keymap.set({ "n" }, "J", "mzJ`z", { desc = "Keep cursor while joining lines" })

vim.keymap.set({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Visual Prev Search Result" })
vim.keymap.set({ "n" }, "N", "'nN'[v:searchforward].'zzzv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Visual Next Search Result" })
vim.keymap.set({ "n" }, "n", "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = "Next Search Result" })

vim.keymap.set({ "n" }, "U", vim.cmd.redo, { desc = "Redo" })

vim.keymap.set({ "n" }, "[d", Maps.diagnostic_goto(-1), { desc = "Prev Diagnostic" })
vim.keymap.set({ "n" }, "[e", Maps.diagnostic_goto(-1, vim.diagnostic.severity.ERROR), { desc = "Prev Error" })
vim.keymap.set({ "n" }, "[w", Maps.diagnostic_goto(-1, vim.diagnostic.severity.WARN), { desc = "Prev Warning" })
vim.keymap.set({ "n" }, "]d", Maps.diagnostic_goto(1), { desc = "Next Diagnostic" })
vim.keymap.set({ "n" }, "]e", Maps.diagnostic_goto(1, vim.diagnostic.severity.ERROR), { desc = "Next Error" })
vim.keymap.set({ "n" }, "]w", Maps.diagnostic_goto(1, vim.diagnostic.severity.WARN), { desc = "Next Warning" })

vim.keymap.set({ "n" }, "<leader>td", function()
	Config.keymap.toggle.diagnostics()
end, { desc = "[T]oggle [D]iagnostics" })

vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })

vim.keymap.set({ "n", "v" }, "z=", function()
	local word = vim.fn.expand("<cword>")
	local suggestions = vim.fn.spellsuggest(word)

	vim.ui.select(
		suggestions,
		{ prompt = ("Spelling suggestions for %q: "):format(word) },
		vim.schedule_wrap(function(selected)
			if selected then
				vim.cmd.normal({ args = { ("ciw%s"):format(selected) }, bang = true })
			end
		end)
	)
end)

vim.keymap.set({ "n" }, "<leader>tn", function()
	local toggle_relative_number = Config.keymap.toggle.option("Relative Number")
	toggle_relative_number()
end, { desc = "[T]oggle [N]umber" })

---@class user.Keymap
---@field maps user.Keymap.maps
---@field toggle user.Keymap.Toggle
---@overload fun(prefix:string):vim.keymap.set.function
return setmetatable({}, {
	---@param t user.Keymap
	---@param prefix? user.Keymap.module_prefix
	---@return vim.keymap.set.function
	__call = function(t, prefix)
		return t.maps.init_mapping(prefix)
	end,
	__index = function(t, k)
		---@diagnostic disable-next-line: no-unknown
		t[k] = require("user.keymap." .. k)
		return t[k]
	end,
})
