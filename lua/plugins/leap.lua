---@type LazySpec
local M = { "ggandor/leap.nvim" }

M.dependencies = {
	{ "tpope/vim-repeat", event = require("util").constants.lazy_event },
}

return M
