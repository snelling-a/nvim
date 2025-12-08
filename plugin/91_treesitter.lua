vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } })

vim.api.nvim_create_autocmd({ "PackChanged" }, {
	desc = "Handle nvim-treesitter updates",
	group = vim.api.nvim_create_augroup("nvim-treesitter.update-handler", { clear = true }),
	callback = function(event)
		if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
			vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
			---@diagnostic disable-next-line: param-type-mismatch
			local ok = pcall(vim.cmd, "TSUpdate")
			if ok then
				vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
			else
				vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
			end
		end
	end,
})

local extra_languages = {
	"luadoc",
	"jsdoc",
	"vimdoc",
}

local function is_installed(lang)
	return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) > 0
end

local function parser_exists(lang)
	local parsers = require("nvim-treesitter.parsers")
	return parsers[lang] ~= nil
end

local function ensure_installed(lang)
	if is_installed(lang) then
		return true
	end
	if not parser_exists(lang) then
		return false
	end
	local ok = pcall(require("nvim-treesitter").install, { lang })
	return ok
end

for _, lang in ipairs(extra_languages) do
	ensure_installed(lang)
end

local group = vim.api.nvim_create_augroup("treesitter-auto-install", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(ev)
		local ft = ev.match
		local lang = vim.treesitter.language.get_lang(ft)
		if not lang then
			return
		end

		if is_installed(lang) then
			vim.treesitter.start(ev.buf)
			return
		end

		if ensure_installed(lang) then
			vim.defer_fn(function()
				if vim.api.nvim_buf_is_valid(ev.buf) and is_installed(lang) then
					vim.treesitter.start(ev.buf)
				end
			end, 1000)
		end
	end,
	desc = "Auto-install treesitter parser and start highlighting",
})
