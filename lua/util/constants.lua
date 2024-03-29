---@class util.constants
local M = {}

-- directory used by ghq
M.dev_dir = os.getenv("DEV") or ("%s/dev/github.com"):format(os.getenv("HOME"))

M.javascript_typescript = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

M.no_format = {
	"checkhealth",
	"copilot.lua",
	"dap*",
	"diffview",
	"DressingSelect",
	"fugitive",
	"fugitiveblame",
	"git",
	"help",
	"log",
	"minifiles",
	"neotest-*",
	"netrw",
	"Outline",
	"PlenaryTestPopup",
	"pr",
	"scratch",
	"starter",
	"toggleterm",
	"undotree",
}

M.lazy_event = {
	"BufNewFile",
	"BufReadPost",
	"BufWritePre",
	"SessionLoadPost",
}

return M
