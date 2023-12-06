local float_opts = { border = "rounded" }

---@type LazySpec
local M = { "akinsho/toggleterm.nvim" }

M.cmd = { "ToggleTerm" }

---@diagnostic disable-next-line: assign-type-mismatch
M.keys = function()
	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({
		cmd = "lazygit",
		direction = "float",
		float_opts = float_opts,
		hidden = true,
	})

	return {
		{
			"<c-\\>",
			desc = "ToggleTerm",
		},
		{
			"<leader>gg",
			function()
				lazygit:toggle()
			end,
			desc = "LazyGit",
		},
	}
end

---@type TermCreateArgs
M.opts = {
	direction = "float",
	float_opts = float_opts,
	open_mapping = [[<c-\>]],
}

function M.config(_, opts)
	---@param ev Ev
	local function set_terminal_keymaps(ev)
		local keymap_opts = {
			buffer = ev.buf,
			nowait = true,
		}
		vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], keymap_opts)
		vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], keymap_opts)
		vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], keymap_opts)
		vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], keymap_opts)
	end

	require("toggleterm").setup(opts)

	vim.api.nvim_create_autocmd({ "TermOpen" }, {
		callback = set_terminal_keymaps,
		group = require("autocmd").augroup("ToggleTerm"),
		pattern = "term://*",
	})
end

return M
