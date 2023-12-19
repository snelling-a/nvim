local float_opts = { border = "rounded" }
local lazygit_desc = "LazyGit"

---@type LazySpec
local M = { "akinsho/toggleterm.nvim" }

M.keys = {
	{
		"<c-\\>",
		desc = "ToggleTerm",
	},
	{
		"<leader>gg",
		desc = lazygit_desc,
	},
}

---@type TermCreateArgs
M.opts = {
	direction = "float",
	float_opts = float_opts,
	open_mapping = [[<c-\>]],
}

function M.config(_, opts)
	local Keymap = require("keymap")

	---@param ev Ev
	local function set_terminal_keymaps(ev)
		---@param lhs string
		---@param rhs string
		---@param desc string
		local function map(lhs, rhs, desc)
			Keymap.tmap(
				lhs,
				rhs,
				require("util").tbl_extend_force({
					buffer = ev.buf,
					nowait = true,
				}, { desc = desc })
			)
		end

		map("<esc><esc>", [[<C-\><C-n>]], "[Esc] to normal mode")
		map("<C-h>", [[<Cmd>wincmd h<CR>]], "Move window right")
		map("<C-l>", [[<Cmd>wincmd l<CR>]], "Move window [l]eft")
		map("<C-w>", [[<C-\><C-n><C-w>]], "Execute [w]indow command")
	end

	require("toggleterm").setup(opts)

	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({
		cmd = "lazygit",
		direction = "float",
		float_opts = float_opts,
		hidden = true,
	})

	Keymap.leader("gg", function()
		lazygit:toggle()
	end, { desc = lazygit_desc })

	vim.api.nvim_create_autocmd({ "TermOpen" }, {
		callback = set_terminal_keymaps,
		group = require("autocmd").augroup("ToggleTerm"),
		pattern = "term://*",
	})
end

return M
