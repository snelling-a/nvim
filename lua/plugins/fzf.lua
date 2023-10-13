local Icons = require("config.ui.icons")
local get_prompt = require("config.util").get_prompt

local preview_pager = vim.fn.executable("delta") and "delta --width=$FZF_PREVIEW_COLUMNS"

--- @type LazySpec
local M = {
	"ibhagwan/fzf-lua",
}

M.cmd = {
	"FzfLua",
}

M.dependencies = {
	"nvim-tree/nvim-web-devicons",
}

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		"<C-p>",
		function() require("fzf-lua").files() end,
		desc = "Open [p]roject files",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<C-r>",
		function() require("fzf-lua").live_grep() end,
		desc = "[R]un live grep",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader><space>",
		function() require("fzf-lua").builtin() end,
		desc = "Open builtins",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader><tab>",
		function() require("fzf-lua").keymaps() end,
		desc = "Show keymaps",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>b",
		function() require("fzf-lua").buffers() end,
		desc = "Show [b]uffers",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>fh",
		function() require("fzf-lua").help_tags() end,
		desc = "[H]elp",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>fr",
		function() require("fzf-lua").lsp_finder() end,
		desc = "All lsp locations combined",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>qf",
		function() require("fzf-lua").quickfix() end,
		desc = "[Q]uick [F]ix menu",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"?",
		function() require("fzf-lua").blines() end,
		desc = "Search current buffer",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		'""',
		function() require("fzf-lua").registers() end,
		desc = "View registers",
	},
}

M.opts = {
	blines = {
		prompt = get_prompt(Icons.location.line),
	},
	btags = {
		prompt = get_prompt(Icons.misc.tag),
	},
	buffers = {
		prompt = get_prompt(Icons.file.buffer),
		cwd_only = true,
	},
	colorschemes = {
		live_preview = true,
		prompt = get_prompt(Icons.kind_icons.Color),
	},
	commands = {
		sort_lastused = true,
	},
	diagnostics = {
		cwd_only = true,
		file_icons = true,
		git_icons = true,
		prompt = get_prompt(Icons.misc.tools),
		severity_limit = "warning",
	},
	files = {
		cwd_prompt = false,
		fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules",
		fzf_opts = {
			["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
		},
		prompt = get_prompt(Icons.misc.files),
	},
	git = {
		bcommits = {
			prompt = get_prompt(Icons.git.commit_2),
		},
		branches = {
			prompt = get_prompt(Icons.git.branch),
		},
		commits = {
			preview_pager = preview_pager,
			prompt = get_prompt(Icons.git.commit),
		},
		files = {
			prompt = get_prompt(Icons.git.folder),
		},
		icons = {
			["A"] = {
				icon = Icons.git.added,
				color = "green",
			},
			["D"] = {
				icon = Icons.git.removed,
				color = "red",
			},
			["M"] = {
				icon = Icons.git.modified,
				color = "magenta",
			},
		},
		stash = {
			prompt = get_prompt(Icons.git.stash),
		},
		status = {
			preview_pager = preview_pager,
			prompt = get_prompt(Icons.git.status),
		},
	},
	grep = {
		fzf_opts = {
			["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
		},
		prompt = get_prompt(Icons.misc.search),
	},
	keymap = {
		fzf = {
			["alt-a"] = "select-all+accept",
		},
	},
	lines = {
		prompt = get_prompt(Icons.location.line),
	},
	lsp = {
		code_actions = {
			prompt = get_prompt(Icons.misc.code_action),
		},
		cwd_only = true,
		finder = {
			git_icons = true,
			includeDeclaration = true,
			prompt = get_prompt(Icons.cmp.nvim_lsp),
		},
		git_icons = true,
		symbols = {
			symbol_icons = Icons.kind_icons,
			symbol_fmt = function(s) return "|" .. s .. "|" end,
		},
	},
	oldfiles = {
		cwd_only = true,
		prompt = get_prompt(Icons.file.oldfiles),
	},
	previewers = {
		bat = {
			args = "--style=numbers,changes --color always",
			config = nil,
			theme = "base16",
		},
		cmd = "man -P cat %s | col -bx", -- OSX
		git_diff = {
			pager = preview_pager,
		},
	},
	quickfix = {
		file_icons = true,
		git_icons = true,
	},
	quickfix_stack = {
		marker = Icons.misc.right,
	},
	tabs = {
		prompt = get_prompt(Icons.file.tab),
	},
	tags = {
		prompt = get_prompt(Icons.misc.tag),
	},
}

function M.config(_, opts)
	local fzf_lua = require("fzf-lua")

	vim.api.nvim_create_autocmd("VimResized", {
		callback = fzf_lua.redraw,
		desc = "Resize FzfLua when window resizes",
		group = require("config.util").augroup("FzfLuaResize"),
		pattern = "*",
	})

	fzf_lua.setup(opts)
end

return M
