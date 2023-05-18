local icons = require("config.ui.icons")

local preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS"

---@param icon string
---@return string
local function get_prompt(icon) return string.format("%s %s ", icon, icons.misc.right) end

local M = { "ibhagwan/fzf-lua" }

M.dependencies = { "nvim-tree/nvim-web-devicons" }

M.keys = {
	{ "<C-p>", function() require("fzf-lua").files() end, desc = "Open [p]roject files" },
	{ "<C-r>", function() require("fzf-lua").live_grep() end, desc = "[R]un live grep" },
	{ "<leader><space>", function() require("fzf-lua").builtin() end, desc = "Open builtins" },
	{ "<leader><tab>", function() require("fzf-lua").keymaps() end, desc = "Show keymaps" },
	{ "<leader>b", function() require("fzf-lua").buffers() end, desc = "Show [b]uffers" },
	{ "<leader>ca", function() require("fzf-lua").lsp_code_actions() end, desc = "[C]ode [a]ction" },
	{ "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, desc = "Show [d]ocument [s]ymbols" },
	{ "<leader>fh", function() require("fzf-lua").help_tags() end, desc = "[H]elp" },
	{ "<leader>q", function() require("fzf-lua").quickfix() end },
	{ "<leader>qf", function() require("fzf-lua").quickfix() end },
	{ "fr", function() require("fzf-lua").lsp_finder() end, desc = "All lsp locations combined" },
	{ "?", function() require("fzf-lua").blines() end, desc = "Search current buffer" },
	{ '""', function() require("fzf-lua").registers() end, desc = "View registers" },
}

M.opts = {
	blines = { prompt = get_prompt(icons.location.line) },
	btags = { prompt = get_prompt(icons.misc.tag) },
	buffers = { prompt = get_prompt(icons.file.buffers), cwd_only = true },
	colorschemes = {
		live_preview = true,
		post_reset_cb = function() require("feline").reset_highlights() end,
		prompt = get_prompt(icons.misc.color),
	},
	commands = { sort_lastused = true },
	diagnostics = {
		cwd_only = true,
		file_icons = true,
		git_icons = true,
		prompt = get_prompt(icons.misc.tools),
		severity_limit = "warning",
	},
	files = {
		fd_opts = "--color=never --type f --hidden --no-ignore --follow --exclude .git --exclude node_modules",
		fzf_opts = { ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history" },
		prompt = get_prompt(icons.misc.files),
	},
	git = {
		bcommits = { prompt = get_prompt(icons.git.commit_2) },
		branches = { prompt = get_prompt(icons.git.branch) },
		commits = {
			cmd = "git lsa --color",
			preview_pager = preview_pager,
			prompt = get_prompt(icons.misc.git_commit),
		},
		files = { prompt = get_prompt(icons.git.folder) },
		icons = {
			["A"] = { icon = icons.git.added, color = "green" },
			["D"] = { icon = icons.git.removed, color = "red" },
			["M"] = { icon = icons.git.modified, color = "magenta" },
		},
		stash = { prompt = get_prompt(icons.git.stash) },
		status = { preview_pager = preview_pager, prompt = get_prompt(icons.git.status) },
	},
	grep = {
		fzf_opts = { ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history" },
		prompt = get_prompt(icons.misc.search),
	},
	lines = { prompt = get_prompt(icons.location.line) },
	lsp = {
		code_actions = {
			prompt = get_prompt(icons.misc.code_action),
			async_or_timeout = 5000,
			winopts = {
				row = 0.40,
				height = 0.35,
				width = 0.60,
			},
		},
		cwd_only = true,
		finder = { git_icons = true, includeDeclaration = true, prompt = get_prompt(icons.cmp.nvim_lsp) },
		git_icons = true,
		symbols = { symbol_icons = icons.kind_icons, symbol_fmt = function(s) return "|" .. s .. "|" end },
	},
	oldfiles = { prompt = get_prompt(icons.file.oldfiles), cwd_only = true },
	previewers = {
		bat = { args = "--style=numbers,changes --color always", config = nil, theme = "base16" },
		cmd = "man -P cat %s | col -bx", -- OSX
		git_diff = { pager = preview_pager },
	},
	quickfix = { file_icons = true, git_icons = true },
	quickfix_stack = { marker = icons.misc.right },
	tabs = { prompt = get_prompt(icons.file.tab) },
	tags = { prompt = get_prompt(icons.misc.tag) },
	winopts = { preview = { default = "bat" } },
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
