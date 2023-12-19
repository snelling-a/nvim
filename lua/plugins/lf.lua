local desc = "[O]pen lf"

---@type LazySpec
local M = { "lmburns/lf.nvim" }


M.dependencies = { "akinsho/toggleterm.nvim" }

M.keys = { "<M-o>", desc = desc }

---@type Lf.Config
M.opts = {
	border = "rounded",
	default_actions = { ["<C-s>"] = "split" },
}

function M.config(_, opts)
	require("lf").setup(opts)

	require("keymap").nmap("<M-o>", vim.cmd.Lf, { desc = desc })
end

return M
