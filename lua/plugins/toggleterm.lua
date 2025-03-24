---@type LazySpec
return {
	"akinsho/toggleterm.nvim",
	cmd = { "LazyLog" },
	keys = {
		{ "<c-\\>", desc = "ToggleTerm" },
		{ "<leader>gg", desc = "LazyGit" },
	},
	config = function()
		local float_opts = { border = "rounded" }

		require("toggleterm").setup({
			direction = "float",
			float_opts = float_opts,
			open_mapping = [[<c-\>]],
		})

		---@param args? string|string[]
		---@return Terminal
		local function get_term(args)
			if type(args) == "string" then
				args = { args }
			end
			local cmd_args = vim.list_extend({ "lazygit" }, args or {})

			---@type TermCreateArgs
			local term = {
				cmd = table.concat(cmd_args, " "),
				direction = "float",
				float_opts = float_opts,
				hidden = true,
			}

			local Terminal = require("toggleterm.terminal").Terminal
			return Terminal:new(term)
		end

		local map = require("user.keymap.util").map("Toggleterm")

		map({ "n" }, "<leader>gg", function()
			local lazygit = get_term()
			lazygit:toggle()
		end, { desc = "LazyGit" })

		vim.api.nvim_create_user_command("LazyLog", function(ctx)
			---@type string|string[]
			local args = "log"

			if ctx.bang or ctx.args == "file" then
				local file = vim.trim(vim.api.nvim_buf_get_name(0))
				args = { "--filter", file }
			end

			local lazygit = get_term(args)
			lazygit:toggle()
		end, {
			bang = true,
			complete = function()
				return { "file" }
			end,
			desc = "LazyGit log",
			nargs = "?",
		})

		vim.api.nvim_create_autocmd({ "TermOpen" }, {
			callback = function(event)
				---@param lhs string Left-hand side |{lhs}| of the mapping
				---@param rhs string Right-hand side |{rhs}| of the mapping
				---@param desc string vim.api.keyset.keymap description
				local function term_map(lhs, rhs, desc)
					map(
						{ "t" },
						lhs,
						rhs,
						vim.tbl_extend("force", {
							buffer = event.buf,
							nowait = true,
						}, { desc = desc })
					)
				end

				term_map("<esc><esc>", [[<C-\><C-n>]], "[Esc] to normal mode")
				term_map("<C-h>", [[<Cmd>wincmd h<CR>]], "Move window right")
				term_map("<C-l>", [[<Cmd>wincmd l<CR>]], "Move window [l]eft")
				term_map("<C-w>", [[<C-\><C-n><C-w>]], "Execute [w]indow command")
			end,
			group = vim.api.nvim_create_augroup("ToggleTerm", {}),
			pattern = "term://*",
		})
	end,
}
