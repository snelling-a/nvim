---@class user.Lsp.overrides
local M = {}

function M.on_attach()
	local config = {
		border = "rounded",
		max_height = math.floor(vim.o.lines * 0.5),
		max_width = math.floor(vim.o.columns * 0.6),
	}

	local document_highlight = vim.lsp.buf.document_highlight
	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.buf.document_highlight = function()
		local string_types = {
			"string",
			"string_fragment",
			"string_content",
			"template_string",
			"document",
		}

		local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
		while node ~= nil do
			local node_type = node:type()
			if vim.tbl_contains(string_types, node_type) then
				return
			end
			node = node:parent()
		end
		document_highlight()
	end

	local document_symbol = vim.lsp.buf.document_symbol
	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.buf.document_symbol = function()
		return document_symbol({
			on_list = function(t)
				t = t or {}

				local items = table.sort(t.items or {}, function(a, b)
					return a.lnum < b.lnum
				end)

				---@param item {text:string}
				vim.tbl_map(function(item)
					local text = (item.text or ""):gsub("%[(%w+)%]", function(match)
						return Config.icons.kind_icons[match] or item.text
					end)

					item.text = text
				end, t.items)

				local what = vim.tbl_extend("force", t, {
					title = "Symbols in " .. vim.fn.expand("%:t"),
					items = items,
				})

				vim.fn.setloclist(0, {}, "r", what)
				vim.cmd.lopen()
			end,
		})
	end

	local hover = vim.lsp.buf.hover
	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.buf.hover = function()
		return hover(config)
	end

	local references = vim.lsp.buf.references
	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.buf.references = function()
		return references({ includeDeclaration = false }, {
			on_list = function(t)
				t = t or {}
				local search_term = vim.fn.expand("<cword>")

				local what = vim.tbl_extend("force", t, {
					title = ("%d references to %q"):format(#t.items, search_term),
					items = t.items,
				})
				what.context.includeDeclaration = false

				vim.fn.setloclist(0, {}, "r", what)
				vim.cmd.lopen()
			end,
		})
	end

	local signature_help = vim.lsp.buf.signature_help
	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.buf.signature_help = function()
		return signature_help(config)
	end
end

return M
