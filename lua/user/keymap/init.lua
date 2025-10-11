local _set = vim.keymap.set

---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false

	return _set(mode, lhs, rhs, opts)
end

local Maps = require("user.keymap.util")

Maps.create_breakpoint("(")
Maps.create_breakpoint(")")
Maps.create_breakpoint(",")
Maps.create_breakpoint(".")
Maps.create_breakpoint(";")
Maps.create_breakpoint("<")
Maps.create_breakpoint(">")
Maps.create_breakpoint("[")
Maps.create_breakpoint("]")
Maps.create_breakpoint("{")
Maps.create_breakpoint("}")

Maps.indent("<")
Maps.indent(">")

Maps.keepjumps("{")
Maps.keepjumps("}")

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

vim.keymap.set({ "n" }, "<A-Down>", function()
	vim.cmd.resize({ "-2" })
end, { desc = "Decrease Window Height" })
vim.keymap.set({ "n" }, "<A-Up>", function()
	vim.cmd.resize({ "+2" })
end, { desc = "Increase Window Height" })

---@param direction "decrease"|"increase"
local function vertical_resize(direction)
	local directions = { decrease = "-", increase = "+" }
	vim.cmd.resize({ directions[direction] .. "2", mods = { vertical = true } })
end

local is_ghostty = (vim.env.TERM or ""):match("ghostty")
vim.keymap.set("n", is_ghostty and "<M-b>" or "<A-Left>", function()
	vertical_resize("decrease")
end, { desc = "Decrease Window Width" })
vim.keymap.set("n", is_ghostty and "<M-f>" or "<A-Right>", function()
	vertical_resize("increase")
end, { desc = "Increase Window Width" })

vim.keymap.set("n", "<Left>", "zh", { desc = "Scroll left" })
vim.keymap.set("n", "<Right>", "zl", { desc = "Scroll right" })
vim.keymap.set("n", "<S-Left>", "zH", { desc = "Center left" })
vim.keymap.set("n", "<S-Right>", "zL", { desc = "Center right" })

vim.keymap.set({ "n" }, "<C-z>", "<nop>", { desc = "Disable `:stop` keymap" })

vim.keymap.set({ "n" }, "<Esc>", Maps.clear, { desc = "Redraw / Clear hlsearch / Diff Update" })

vim.keymap.set({ "n" }, "<leader>K", function()
	vim.cmd.normal({ args = { "K" }, bang = true })
end, { desc = "Keywordprg" })

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
vim.keymap.set({ "n" }, "g/", function()
	local last_search = vim.fn.getreg("/")

	---@diagnostic disable-next-line: param-type-mismatch
	local okay = pcall(vim.cmd, "vimgrep /" .. last_search .. "/j %")
	if not okay then
		vim.notify("No previous search pattern found", vim.log.levels.WARN)
		return
	end

	vim.cmd.copen()
end, { desc = "Search for the last search pattern in the current file and open the quickfix list" })

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
	vim.notify(("Diagnostics %s"):format(is_enabled and "disabled" or "enabled"))
end, { desc = "[T]oggle [D]iagnostics" })
vim.keymap.set({ "n" }, "<leader>tw", function()
	---@type boolean
	---@diagnostic disable-next-line: undefined-field
	local wrap = vim.opt_local.wrap:get()

	vim.opt_local.wrap = not wrap
	vim.notify(("Wrap %s"):format(wrap and "disabled" or "enabled"))
end, { desc = "[T]oggle [W]rap" })
vim.keymap.set({ "n" }, "<leader>tn", function()
	if require("util").is_disabled_filetype() then
		return
	end
	vim.g.relativenumber = not vim.g.relativenumber

	vim.opt_local.relativenumber = vim.g.relativenumber
	vim.notify(("Relative number %s"):format(vim.g.relativenumber and "enabled" or "disabled"))
end, { desc = "[T]oggle Relative[n]umber" })

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
end, { desc = "Spelling suggestions for the word under the cursor" })

vim.keymap.set({ "n" }, "ycc", "yygccp", { remap = true, desc = "Duplicate line and comment the first line" })
vim.keymap.set({ "x" }, "/", "<Esc>/\\%V", { desc = "Search in visual mode" })

vim.keymap.set({ "v" }, "Y", function()
	local view = vim.fn.winsaveview()
	vim.cmd.normal({ args = { "Y" }, bang = true })
	vim.fn.winrestview(view)
end, { desc = "Keep cursor position when yanking in visual mode" })

vim.keymap.set("n", "<leader>u", function()
	local loaded, undotree = pcall(require, "undotree")

	if not loaded then
		pcall(vim.cmd.packadd, "nvim.undotree")
		undotree = require("undotree")
	end

	local split_width = math.floor(vim.o.columns * 0.25 + 0.5)

	undotree.open({ command = split_width .. "vnew" })
end, { desc = "Open Undo Tree" })
