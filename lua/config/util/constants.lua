local M = {}

M.dev_dir = os.getenv("DEV") or (os.getenv("HOME") .. "/dev/github.com/")

M.javascript_typescript = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

M.lazy_event = {
	"BufAdd",
	"SessionLoadPost",
}

M.no_format = {
	"alpha",
	"checkhealth",
	"copilot.lua",
	"dapui_*",
	"diffview",
	"DressingSelect",
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
	"neo-tree",
	"netrw",
	"noice",
	"notify",
	"NvimSeparator",
	"NvimTree",
	"ObsidianBacklinks",
	"Outline",
	"packer",
	"pr",
	"qf",
	"starter",
	"toggleterm",
	"Trouble",
	"undotree",
}

return M
