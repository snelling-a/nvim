local M = {}

function M.on_attach()
	local references = vim.lsp.buf.references
	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.buf.references = function()
		return references({ includeDeclaration = false }, { loclist = true })
	end

	local ok, icons = pcall(require, "mini.icons")

	local document_symbol = vim.lsp.buf.document_symbol
	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.buf.document_symbol = ok
			and function()
				return document_symbol({
					on_list = function(t)
						t = t or {}

						---@diagnostic disable-next-line: no-unknown
						local items = table.sort(t.items or {}, function(a, b)
							return a.lnum < b.lnum
						end)

						---@param item {text:string}
						vim.tbl_map(function(item)
							local new_text = (item.text or ""):gsub("%[(%w+)%]", function(match)
								return icons.get("lsp", match:lower()) .. "  " .. require("icons").fillchars.vert
							end)

							item.text = new_text
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
		or document_symbol
end

return M
