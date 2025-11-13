vim.opt_local.conceallevel = 3
vim.opt_local.cursorcolumn = true
vim.opt_local.cursorlineopt = "number"
vim.opt_local.foldenable = false
vim.opt_local.foldexpr = "v:lua.JsonFolds()"
vim.opt_local.foldmarker = "{,}"
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldnestmax = 5

vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "SortJSON", function()
	vim.cmd([[%!jq . --sort-keys]])
end, {
	desc = "Sort JSON with `jq`",
})

function _G.JsonFolds()
	local line = vim.fn.getline(vim.v.lnum)
	local inc = vim.fn.count(line, "{")
	local dec = vim.fn.count(line, "}")
	local level = inc - dec
	if level == 0 then
		return "="
	elseif level > 0 then
		return "a" .. level
	elseif level < 0 then
		return "s" .. -level
	end
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*/obsidian-web-clipper-settings.json",
	callback = function()
		local jq_lines = {
			'(.property_types |= (select(type=="array")|sort_by(.name)))',
			"| to_entries",
			"| map(",
			'    if (.value|type=="object") and ((.value.properties?|type)=="array")',
			"    then (.value.properties |= sort_by(.name))|.",
			"    else . end)",
			"| from_entries",
		}
		local jq_filter = table.concat(jq_lines, " ")

		local function sort_obsidian_web_clipper_settings()
			vim.cmd("%!jq --sort-keys " .. vim.fn.shellescape(jq_filter))
		end

		vim.api.nvim_create_user_command(
			"SortClipperSettings",
			sort_obsidian_web_clipper_settings,
			{ desc = "Sort Obsidian Web Clipper settings (using jq)" }
		)
	end,
	desc = "Add :SortClipperSettings for Obsidian Web Clipper settings files",
})
