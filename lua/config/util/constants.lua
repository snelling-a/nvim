local vault_directory = os.getenv("NOTES") or os.getenv("HOME") .. "/notes"

local Constants = {}

Constants.javascript_typescript = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

Constants.mason_dir = ""

Constants.no_format = {
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
	"query",
	"spectre_panel",
	"toggleterm",
	"Trouble",
	"undotree",
}

Constants.obsidian = { vault_directory = vault_directory, is_vault_directory = vim.fn.getcwd() == vault_directory }

Constants.dev_dir = os.getenv("DEV") or os.getenv("HOME") .. "/dev/github.com/"

return Constants
