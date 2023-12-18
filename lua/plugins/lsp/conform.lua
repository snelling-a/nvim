local Util = require("util")

---@type LazySpec
local M = { "stevearc/conform.nvim" }

M.dependencies = { "mason.nvim" }

M.event = require("util").constants.lazy_event

M.keys = {
	{
		"<leader>cF",
		function()
			require("conform").format({ formatters = { "injected" } })
		end,
		mode = { "n", "v" },
		desc = "Format Injected Langs",
	},
}

M.init = function()
	require("autocmd").on_very_lazy(function()
		require("lsp").format.register({
			name = "conform.nvim",
			priority = 100,
			primary = true,
			format = function(buf)
				local opts = require("_lazy").get_opts("conform")
				require("conform").format(Util.merge(opts.format, { bufnr = buf }))
			end,
			sources = function(buf)
				local formatters = require("conform").list_formatters(buf)
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

	opts = vim.tbl_extend("force", opts, {
		format = {
			timeout_ms = 3000,
			async = false,
			quiet = false,
		},
		---@type table<string, conform.FormatterUnit>
		formatters_by_ft = {},
	})

	return opts
end

M.config = setup

return M
