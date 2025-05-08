local _set = vim.keymap.set

---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false

	return _set(mode, lhs, rhs, opts)
end

local Maps = require("user.keymap.util")

Maps.create_breakpoint(")")
Maps.create_breakpoint(",")
Maps.create_breakpoint(".")
Maps.create_breakpoint(";")
Maps.create_breakpoint(">")
Maps.create_breakpoint("]")
Maps.create_breakpoint("}")

Maps.indent("<")
Maps.indent(">")

Maps.scroll_center("<C-d>")
Maps.scroll_center("<C-u>")

Maps.vertical_move("j")
Maps.vertical_move("k")

Maps.wild("n")
Maps.wild("p")

vim.keymap.set(
	{ "n" },
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/Ig<Left><Left><Left>]],
	{ desc = "[S]earch and replace word under the cursor", silent = false }
)

vim.keymap.set({ "v" }, "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set({ "n" }, "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set({ "i" }, "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set({ "v" }, "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
vim.keymap.set({ "n" }, "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set({ "i" }, "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })

vim.keymap.set({ "n" }, "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set({ "n" }, "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set({ "n" }, "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set({ "n" }, "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set({ "n" }, "<S-Up>", function()
	vim.cmd("resize +2")
end)
vim.keymap.set({ "n" }, "<S-Down>", function()
	vim.cmd("resize -2")
end)
vim.keymap.set({ "n" }, "<S-Left>", function()
	vim.cmd("vertical resize +2")
end)
vim.keymap.set({ "n" }, "<S-Right>", function()
	vim.cmd("vertical resize -2")
end)

vim.keymap.set({ "n" }, "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set({ "n" }, "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set({ "n" }, "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
vim.keymap.set({ "n" }, "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })

vim.keymap.set({ "n" }, "<C-z>", "<nop>", { desc = "Disable `:stop` keymap" })

vim.keymap.set({ "n" }, "<Esc>", Maps.clear, { desc = "Redraw / Clear hlsearch / Diff Update" })

vim.keymap.set({ "n" }, "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

vim.keymap.set({ "n", "v" }, "<leader>e", function()
	vim.cmd.normal({ args = { "%" } })
end, { desc = "Go to matching bracket" })

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
vim.keymap.set({ "n" }, "<C-CR>", "a<CR><Esc>k$", { desc = "Split current line under the cursor" })
vim.keymap.set({ "i" }, "<C-CR>", "<CR><Esc>kA", { desc = "Split current line under the cursor" })

vim.keymap.set(
	{ "n", "o", "x" },
	"N",
	"'nN'[v:searchforward].'zv'",
	{ expr = true, desc = "Visual Prev Search Result" }
)
vim.keymap.set(
	{ "n", "o", "x" },
	"n",
	"'Nn'[v:searchforward].'zv'",
	{ expr = true, desc = "Visual Next Search Result" }
)

vim.keymap.set({ "n" }, "U", vim.cmd.redo, { desc = "Redo" })

vim.keymap.set({ "n" }, "[d", Maps.diagnostic_goto(-1), { desc = "Prev Diagnostic" })
vim.keymap.set({ "n" }, "]d", Maps.diagnostic_goto(1), { desc = "Next Diagnostic" })
vim.keymap.set({ "n" }, "[e", Maps.diagnostic_goto(-1, vim.diagnostic.severity.ERROR), { desc = "Prev Error" })
vim.keymap.set({ "n" }, "]e", Maps.diagnostic_goto(1, vim.diagnostic.severity.ERROR), { desc = "Next Error" })
vim.keymap.set({ "n" }, "[w", Maps.diagnostic_goto(-1, vim.diagnostic.severity.WARN), { desc = "Prev Warning" })
vim.keymap.set({ "n" }, "]w", Maps.diagnostic_goto(1, vim.diagnostic.severity.WARN), { desc = "Next Warning" })

vim.keymap.set({ "n" }, "<leader>td", function()
	local is_enabled = vim.diagnostic.is_enabled()

	vim.diagnostic.enable(not is_enabled)
end, { desc = "[T]oggle [D]iagnostics" })
vim.keymap.set({ "n" }, "<leader>tw", function()
	---@type boolean
	---@diagnostic disable-next-line: undefined-field
	local wrap = vim.opt_local.wrap:get()

	vim.opt_local.wrap = not wrap
end, { desc = "[T]oggle [W]rap" })

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
	---@type boolean
	---@diagnostic disable-next-line: undefined-field
	local is_enabled = vim.opt_local.relativenumber:get()

	vim.opt_local.relativenumber = not is_enabled
end, { desc = "[T]oggle Relative[n]umber" })

vim.keymap.set("n", "ycc", "yygccp", { remap = true, desc = "Duplicate line and comment the first line" })
vim.keymap.set("x", "/", "<Esc>/\\%V", { desc = "Search in visual mode" })
