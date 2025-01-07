---@class user.Lsp.words
local M = {}

---@alias user.Lsp.words.word {from:{[1]:number, [2]:number}, to:{[1]:number, [2]:number}} 1-0 indexed

local ns_id = vim.api.nvim_create_namespace("vim_lsp_references")

function M.setup()
	local handler = vim.lsp.handlers[vim.lsp.protocol.Methods.textDocument_documentHighlight]
	vim.lsp.handlers[vim.lsp.protocol.Methods.textDocument_documentHighlight] = function(err, result, ctx)
		if not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
			return
		end
		vim.lsp.buf.clear_references()
		return handler(err, result, ctx)
	end

	Config.lsp.on_supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, function(_, bufnr)
		Config.autocmd.create_autocmd({ "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }, {
			buffer = bufnr,
			callback = function(event)
				if
					not Config.lsp.client_supports_method(
						event.buf,
						vim.lsp.protocol.Methods.textDocument_documentHighlight
					)
				then
					return false
				end

				if not ({ M.get() })[2] then
					if event.event:find("CursorMoved") then
						vim.lsp.buf.clear_references()
					else
						vim.lsp.buf.document_highlight()
					end
				end
			end,
			group = "LspWords" .. bufnr,
		})
	end)
end

---@return user.Lsp.words.word[] words List of references
---@return number? current Current word index
function M.get()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local current = nil
	local words = {} ---@type user.Lsp.words.word[]
	for _, extmark in ipairs(vim.api.nvim_buf_get_extmarks(0, ns_id, 0, -1, { details = true })) do
		local w = {
			from = { extmark[2] + 1, extmark[3] },
			to = { extmark[4].end_row + 1, extmark[4].end_col },
		}

		words[#words + 1] = w

		if cursor[1] >= w.from[1] and cursor[1] <= w.to[1] and cursor[2] >= w.from[2] and cursor[2] <= w.to[2] then
			current = #words
		end
	end

	return words, current
end

---@param count integer see |vim.v.count1|
function M.jump(count)
	local words, current = M.get()
	if not current then
		return
	end

	current = current + count
	current = (current - 1) % #words + 1

	local target = words[current]
	if target then
		vim.notify("Match: " .. current .. " / " .. #words)
		vim.api.nvim_win_set_cursor(0, target.from)
		Config.keymap.maps.scroll_unfold()
	end
end

return M
