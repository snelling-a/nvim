_G.Config = require("user")

_G.DisabledFiletypes = {
	"checkhealth",
	"copilot-chat",
	"fugitive",
	"fugitiveblame",
	"gitsigns-blame",
	"grug-far",
	"grug-far-help",
	"grug-far-history",
	"help",
	"lazy",
	"log",
	"lspinfo",
	"man",
	"mason",
	"minifiles",
	"neotest-attach",
	"neotest-output",
	"neotest-output-panel",
	"neotest-summary",
	"notify",
	"qf",
	"scratch",
}

_G.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
