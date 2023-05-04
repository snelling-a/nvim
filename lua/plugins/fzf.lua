local icons = require("config.ui.icons")

local preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS"

---@param icon string
---@return string
local function get_prompt(icon) return string.format("%s %s ", icon, icons.misc.right) end

local M = { "ibhagwan/fzf-lua" }
-- local M = {}
M.dir = "~/dev/github.com/ibhagwan/fzf-lua"

M.dependencies = { "nvim-tree/nvim-web-devicons" }

M.keys = {
	{ "<C-p>", function() require("fzf-lua").files() end, desc = "Open [p]roject files" },
	{ "<C-r>", function() require("fzf-lua").live_grep() end, desc = "[R]un live grep" },
	{ "<leader><space>", function() require("fzf-lua").builtin() end, desc = "Open builtins" },
	{ "<leader><tab>", function() require("fzf-lua").keymaps() end, desc = "Show keymaps" },
	{ "<leader>b", function() require("fzf-lua").buffers() end, desc = "Show [b]uffers" },
	{ "<leader>fh", function() require("fzf-lua").help_tags() end, desc = "[H]elp" },
	{
		"<leader>gr",
		function() require("fzf-lua").lsp_references({ ignore_current_line = true }) end,
		desc = "[G]et [R]eference",
	},
	{ "<leader>q", function() require("fzf-lua").quickfix() end },
	{ "<leader>qf", function() require("fzf-lua").quickfix() end },
	{ '""', function() require("fzf-lua").registers() end, desc = "View registers" },
}

---@return table
local function get_diagnostics_signs()
	local signs = {}
	for key, value in pairs(icons.diagnostics) do
		table.insert(signs, { [key] = { text = value, texthl = "Diagnostic" .. key } })
	end
	return unpack(signs)
end

get_diagnostics_signs()
M.opts = {
	diagnostics = {
		prompt = ":Diagnostics❯ ",
		signs = get_diagnostics_signs(),
	},
	files = {
		fd_opts = "--color=never --type f --hidden --no-ignore --follow --exclude .git --exclude node_modules",
		prompt = get_prompt(icons.misc.files),
	},
	git = {
		branches = { prompt = get_prompt(icons.git.branch) },
		commit = { preview_pager = preview_pager, prompt = get_prompt(icons.misc.git_commit) },
		files = { prompt = get_prompt(icons.misc.git) },
		icons = {
			["A"] = { icon = icons.git.added, color = "green" },
			["D"] = { icon = icons.git.removed, color = "red" },
			["M"] = { icon = icons.git.modified, color = "magenta" },
		},
		status = { preview_pager = preview_pager, prompt = get_prompt(icons.misc.git_compare) },
	},
	grep = { prompt = get_prompt(icons.misc.search) },
	previewers = {
		bat = { args = "--style=numbers,changes --color always", config = nil, theme = "base16" },
		git_diff = { pager = preview_pager },
	},
	winopts = { preview = { default = "bat" } },
}

function M.config(_, opts)
	local fzf_lua = require("fzf-lua")

	fzf_lua.deregister_ui_select({}, true)

	vim.api.nvim_create_autocmd("VimResized", { pattern = "*", callback = function() require("fzf-lua").redraw() end })

	fzf_lua.setup(opts)
end

return M
