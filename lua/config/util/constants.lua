local vault_directory = os.getenv("NOTES") or os.getenv("HOME") .. "/notes"

local Constants = {}

Constants.no_format = {
	"",
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
	"NvimTree",
	"ObsidianBacklinks",
	"Outline",
	"packer",
	"qf",
	"query",
	"toggleterm",
	"Trouble",
	"undotree",
}

Constants.obsidian = { vault_directory = vault_directory, is_vault_directory = vim.fn.getcwd() == vault_directory }

return Constants
