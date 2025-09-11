local Autocmd = require("user.autocmd")
local string_weaver = require("user.string-weaver")

---@type table<number, fun(): nil>
local buffer_functions_cache = {}

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = Autocmd.augroup("string-weaver"),
	desc = "Attach StringWeaver to supported filetypes",
	pattern = vim.tbl_keys(string_weaver.supported_filetypes),
	callback = function(args)
		local string_transform_function = string_weaver.get_string_transform_function(args.match)
		if string_transform_function then
			buffer_functions_cache[args.buf] = string_transform_function
			vim.b[args.buf].string_weaver_enabled = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	group = Autocmd.augroup("string-weaver.core"),
	desc = "StringWeaver string transformation",
	callback = function(args)
		if not vim.api.nvim_buf_is_valid(args.buf) then
			return
		end
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		if vim.b[args.buf].string_weaver_enabled == false then
			return
		end

		local fn = buffer_functions_cache[args.buf]
		if fn then
			vim.schedule(fn)
		end
	end,
})

vim.api.nvim_create_user_command("StringWeaverDisable", function()
	vim.b.string_weaver_enabled = false
	string_weaver.notify("Disabled")
end, { desc = "Disable StringWeaver for the current buffer" })
vim.api.nvim_create_user_command("StringWeaverEnable", function()
	vim.b.string_weaver_enabled = true
	string_weaver.notify("Enabled")
end, { desc = "Enable StringWeaver for the current buffer" })
vim.api.nvim_create_user_command("StringWeaverToggle", function()
	vim.b.string_weaver_enabled = not vim.b.string_weaver_enabled
	string_weaver.notify(vim.b.string_weaver_enabled and "Enabled" or "Disabled")
end, { desc = "Toggle StringWeaver for the current buffer" })
