--- @type LazySpec
local M = {
	"kevinhwang91/nvim-bqf",
}

M.dependencies = {
	{
		"junegunn/fzf",
		config = function()
			if vim.fn.executable("fzf") == 1 then
				vim.opt.rtp:append(("%s/opt/fzf"):format(os.getenv("HOMEBREW_PREFIX")))
			end
		end,
	},
}

M.ft = {
	"qf",
}

--- @type BqfConfig
M.opts = {
	auto_resize_height = true,
	func_map = {
		openc = "<CR>",
		pscrolldown = "<C-d>",
		pscrollup = "<C-u>",
		sclear = "<leader>/",
		split = "<C-s>",
		ptogglemode = "<space>p",
	},
	--- @diagnostic disable-next-line: missing-fields
	preview = {
		auto_preview = false,
		should_preview_cb = function(bufnr)
			local should_preview_cb = true
			local bufname = vim.api.nvim_buf_get_name(bufnr)

			if require("config.util").is_buf_big(bufnr) then
				should_preview_cb = false
			elseif bufname:match("^fugitive://") then
				should_preview_cb = false
			end

			return should_preview_cb
		end,
	},
	filter = {
		fzf = {
			action_for = {
				["ctrl-s"] = "split",
				["ctrl-t"] = "tab drop",
				["ctrl-v"] = "vsplit",
			},
			extra_opts = {
				"--bind",
				"ctrl-o:toggle-all",
				"--delimiter",
				"│",
				"--prompt",
				require("config.ui.icons").misc.search,
			},
		},
	},
}

return M
