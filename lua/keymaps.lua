vim.keymap.set({ "n" }, "U", vim.cmd.redo, { desc = "Redo" })
vim.keymap.set({ "n" }, "<Esc>", vim.cmd.nohlsearch, { desc = "Clear search highlight" })

for _, value in ipairs({ ",", ".", ";", "(", ")", "{", "}", "<", ">", "[", "]" }) do
	vim.keymap.set({ "i" }, value, value .. "<c-g>u", { desc = "Add undoable break point at '" .. value .. "'" })
end

for _, value in ipairs({ "j", "k" }) do
	vim.keymap.set({ "n", "x" }, value, function()
		if vim.v.count > 0 and vim.v.count >= 3 then
			return "m'" .. vim.v.count .. value
		else
			return "g" .. value
		end
	end, {
		desc = "Move to " .. value == "j" and "next" or "previous" .. " visual line",
		expr = true,
		noremap = true,
	})
end

vim.keymap.set(
	{ "n" },
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/Ig<Left><Left><Left>]],
	{ desc = "[S]earch and replace word under the cursor", silent = false }
)

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

vim.keymap.set({ "n" }, "<C-CR>", "a<CR><Esc>k$", { desc = "Split current line under the cursor" })
vim.keymap.set({ "i" }, "<C-CR>", "<CR><Esc>kA", { desc = "Split current line under the cursor" })
vim.keymap.set({ "v" }, "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set({ "n" }, "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set({ "i" }, "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set({ "v" }, "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
vim.keymap.set({ "n" }, "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set({ "i" }, "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })

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

vim.keymap.set({ "n" }, "<leader>tw", function()
	---@type boolean
	---@diagnostic disable-next-line: undefined-field
	local wrap = vim.opt_local.wrap:get()

	vim.opt_local.wrap = not wrap
	vim.notify(("Wrap %s"):format(wrap and "disabled" or "enabled"))
end, { desc = "[T]oggle [W]rap" })

vim.keymap.set({ "n" }, "<leader>u", function()
	local loaded, undotree = pcall(require, "undotree")

	if not loaded then
		pcall(vim.cmd.packadd, "nvim.undotree")
		undotree = require("undotree")
	end

	local split_width = math.floor(vim.o.columns * 0.25 + 0.5)

	undotree.open({ command = split_width .. "vnew" })
end, { desc = "Open Undo Tree" })

vim.keymap.set({ "n" }, "<leader>yy", function()
	local absolute = vim.api.nvim_buf_get_name(0)
	if absolute == "" then
		vim.notify("No file name", vim.log.levels.WARN)
		return
	end

	local git_root = vim.fs.root(0, ".git")
	local base = git_root or vim.uv.cwd()
	local path = base and vim.fn.fnamemodify(absolute, ":." .. base) or absolute

	if path:sub(1, 1) == "/" then
		path = vim.fn.fnamemodify(absolute, ":~")
	end

	vim.fn.setreg("+", path)
	vim.notify("Yanked: " .. path)
end, { desc = "[Y]ank file path" })

vim.keymap.set({ "n", "v" }, "<leader>gl", require("gitlink").link, {
	silent = true,
	desc = "Yank git permlink",
})
