vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
})

vim.api.nvim_create_autocmd({ "PackChanged" }, {
	callback = function(args)
		if
			args.data
			and args.data.spec.name == "nvim-treesitter"
			and (args.data.kind == "install" or args.data.kind == "update")
		then
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
	desc = "Handle nvim-treesitter updates",
	group = vim.api.nvim_create_augroup("nvim-treesitter.update-handler", { clear = true }),
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

vim.treesitter.language.add("lua", { luadoc = "luadoc" })

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
			vim.treesitter.start(ev.buf, lang)
			return
		end

		if ensure_installed(lang) then
			vim.defer_fn(function()
				if vim.api.nvim_buf_is_valid(ev.buf) and is_installed(lang) then
					vim.treesitter.start(ev.buf, lang)
				end
			end, 1000)
		end
	end,
	desc = "Auto-install treesitter parser and start highlighting",
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(ev)
		local ft = ev.match
		local lang = vim.treesitter.language.get_lang(ft)
		if not lang then
			return
		end

		if is_installed(lang) then
			vim.defer_fn(function()
				if vim.api.nvim_buf_is_valid(ev.buf) then
					pcall(vim.treesitter.highlighter.new, ev.buf, lang)
				end
			end, 100)
		end
	end,
	desc = "Enable treesitter highlighting",
})

require("nvim-treesitter-textobjects").setup({
	select = { lookahead = true },
	move = { set_jumps = true },
})

local select = require("nvim-treesitter-textobjects.select").select_textobject
local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

local textobjects = {
	{ "af", "@function.outer", "a function" },
	{ "if", "@function.inner", "inner function" },
	{ "ac", "@class.outer", "a class" },
	{ "ic", "@class.inner", "inner class" },
	{ "aa", "@parameter.outer", "a argument" },
	{ "ia", "@parameter.inner", "inner argument" },
	{ "ai", "@conditional.outer", "a if/conditional" },
	{ "ii", "@conditional.inner", "inner if/conditional" },
	{ "al", "@loop.outer", "a loop" },
	{ "il", "@loop.inner", "inner loop" },
}

for _, obj in ipairs(textobjects) do
	local key, query, desc = obj[1], obj[2], obj[3]
	vim.keymap.set({ "x", "o" }, key, function()
		select(query, "textobjects")
	end, { desc = desc })
end

local movements = {
	{ "]f", "@function.outer", "next function" },
	{ "]c", "@class.outer", "next class" },
	{ "]a", "@parameter.outer", "next argument" },
	{ "[f", "@function.outer", "prev function" },
	{ "[c", "@class.outer", "prev class" },
	{ "[a", "@parameter.outer", "prev argument" },
}

for _, m in ipairs(movements) do
	local key, query, desc = m[1], m[2], m[3]
	local is_next = key:sub(1, 1) == "]"
	local fn = is_next and move.goto_next_start or move.goto_previous_start
	vim.keymap.set({ "n", "x", "o" }, key, function()
		fn(query, "textobjects")
	end, { desc = desc })
end

vim.keymap.set("n", "<leader>a", function()
	swap.swap_next("@parameter.inner", "textobjects")
end, { desc = "Swap next argument" })

vim.keymap.set("n", "<leader>A", function()
	swap.swap_previous("@parameter.inner", "textobjects")
end, { desc = "Swap prev argument" })
vim.keymap.set("n", ",tc", require("treesitter-context").toggle, { desc = "Toggle treesitter context" })
