local vault_directory = os.getenv("NOTES") or os.getenv("HOME") .. "/notes"

local Constants = {}

Constants.mason_dir = ""

Constants.no_format = {
	"alpha",
	"checkhealth",
	"dapui_*",
	"diffview",
	"fugitive",
	"fugitiveblame",
	"git",
	"help",
	"lazy",
	"log",
	"lspinfo",
	"mason",
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
