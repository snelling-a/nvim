--- @type LazySpec
local M = {
	"chrisgrieser/nvim-puppeteer",
}

M.event = require("config.util.constants").lazy_event

M.ft = {
	"javascript",
	"typescript",
	"typescriptreact",
	"javascriptreact",
}

return M
