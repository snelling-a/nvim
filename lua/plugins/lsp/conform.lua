local Util = require("util")

---@type LazySpec
local M = { "stevearc/conform.nvim" }

M.dependencies = { "mason.nvim" }

M.event = require("util").constants.lazy_event

M.keys = {
	{ "<leader>cF", mode = { "n", "v" }, desc = "Format Injected Langs" },
}

M.init = function()
	require("autocmd").on_very_lazy(function()
		require("lsp") --[[@as LSP]]
			.format
			.register({
				format = function(bufnr)
					require("conform").format({
						async = false,
						bufnr = bufnr,
						quiet = false,
						timeout_ms = 3000,
					})
				end,
				name = "conform.nvim",
				primary = true,
				priority = 100,
				sources = function(bufnr)
					local formatters = require("conform").list_formatters(bufnr)
					---@param v conform.FormatterInfo
					return vim.tbl_map(function(v)
						return v.name
					end, formatters)
				end,
			})
	end)
end

---@param opts ConformOpts|{formatters:table}
local function setup(_, opts)
	for _, formatter in pairs(opts.formatters or {}) do
		if type(formatter) == "table" then
			if formatter.extra_args then
				formatter.prepend_args = formatter.extra_args
			end
		end
	end

	require("keymap").leader("cF", function()
		require("conform").format({ formatters = { "injected" } })
	end, { desc = "Format Injected Langs" }, { "n", "v" })

	require("conform").setup(opts)
end

---@class ConformOpts
function M.opts(_, opts)
	local plugin = require("lazy.core.config").plugins["conform.nvim"]
	if plugin.config ~= setup then
		Util.logger:error({
			"Don't set `plugin.config` for `conform.nvim`.",
			"This will break formatting.",
		})
	end

	return vim.tbl_extend("force", {
		---@type table<string, conform.FormatterUnit>
		formatters_by_ft = {},
	}, opts)
end

M.config = setup

return M
