local utils = require("utils")

utils.nmap("<leader>n", vim.cmd.NvimTreeToggle, { desc = "NvimTreeToggle" })
utils.nmap("<leader>m", vim.cmd.NvimTreeFindFileToggle, { desc = "NvimTreeFindFileToggle" })

local function on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	api.config.mappings.default_on_attach(bufnr)

	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

local renderer = {
	add_trailing = true,
	highlight_git = true,
	highlight_opened_files = "all",
	highlight_modified = "icon",
	icons = { git_placement = "signcolumn", modified_placement = "signcolumn" },
	special_files = {
		"Cargo.toml",
		"Makefile",
		"README.md",
		"package.json",
		"readme.md",
	},
}

local view = {
	-- mappings = { list = { { key = "?", action = "toggle_help" } } },
	number = true,
	relativenumber = true,
	side = "right",
	signcolumn = "number",
}

require("nvim-tree").setup({
	actions = { open_file = { quit_on_open = true } },
	diagnostics = { enable = true },
	filters = { custom = { "^\\.git$" } },
	git = { ignore = false },
	on_attach = on_attach,
	renderer = renderer,
	trash = { cmd = "trash" },
	view = view,
})
