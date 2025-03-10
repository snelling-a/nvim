require("user.autocmd").multi_autocmd_group("cool", function(group)
	vim.api.nvim_create_autocmd({ "InsertEnter" }, {
		group = group,
		callback = function()
			vim.schedule(function()
				vim.cmd("nohlsearch")
			end)
		end,
	})
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = group,
		callback = function()
			local view, rpos = vim.fn.winsaveview(), vim.fn.getpos(".")
			vim.cmd(
				string.format(
					"silent! keepjumps go%s",
					(vim.fn.line2byte(view.lnum) + view.col + 1 - (vim.v.searchforward == 1 and 2 or 0))
				)
			)

			---@diagnostic disable-next-line: param-type-mismatch
			local ok, _ = pcall(vim.cmd, "silent! keepjumps norm! n") ---@type boolean, any
			local insearch = ok
				and (function()
					local npos = vim.fn.getpos(".")
					return npos[2] == rpos[2] and npos[3] == rpos[3]
				end)()
			vim.fn.winrestview(view)
			if not insearch then
				vim.schedule(function()
					vim.cmd("nohlsearch")
				end)
			end
		end,
	})
end)
