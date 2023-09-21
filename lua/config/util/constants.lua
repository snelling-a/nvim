local M = {}

M.dev_dir = os.getenv("DEV") or (os.getenv("HOME") .. "/dev/github.com/")

M.javascript_typescript = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

M.no_format = {
	"alpha",
	"checkhealth",
	"dapui_*",
	"diffview",
	"dropbar_menu",
	"fugitive",
	"fugitiveblame",
	"git",
	"Glance",
	"help",
	"lazy",
	"log",
	"lspinfo",
	"mason",
	"netrw",
	"neo-tree",
	"noice",
	"notify",
	"NvimSeparator",
	"NvimTree",
	"ObsidianBacklinks",
	"Outline",
	"packer",
	"pr",
	"qf",
	"spectre_panel",
	"starter",
	"toggleterm",
	"Trouble",
	"undotree",
}

return M
