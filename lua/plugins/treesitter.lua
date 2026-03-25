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

---@type table<string, fun()[]?>
local installing = {}

---@param lang string
---@param callback? fun():nil
local function ensure_installed(lang, callback)
	if is_installed(lang) then
		if callback then
			callback()
		end
		return
	end
	if installing[lang] then
		if callback then
			table.insert(installing[lang], callback)
		end
		return
	end
	if not parser_exists(lang) then
		return
	end
	installing[lang] = { callback }
	---@type boolean, async.Task
	local ok, task = pcall(require("nvim-treesitter").install, { lang })
	if not ok or not task then
		installing[lang] = nil
		vim.schedule(function()
			vim.notify("Treesitter: failed to install " .. lang, vim.log.levels.WARN)
		end)
		return
	end
	task:await(function(err)
		local callbacks = installing[lang] or {}
		installing[lang] = nil
		if err then
			vim.schedule(function()
				vim.notify("Treesitter: failed to install " .. lang .. ": " .. tostring(err), vim.log.levels.WARN)
			end)
			return
		end
		for _, cb in ipairs(callbacks) do
			if cb then
				vim.schedule(cb)
			end
		end
	end)
end

for _, lang in ipairs(extra_languages) do
	ensure_installed(lang)
end

vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-treesitter/runtime")

local group = vim.api.nvim_create_augroup("treesitter-auto-install", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
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

		ensure_installed(lang, function()
			if vim.api.nvim_buf_is_valid(ev.buf) and is_installed(lang) then
				vim.treesitter.start(ev.buf, lang)
			end
		end)
	end,
	desc = "Auto-install treesitter parser and start highlighting",
})

require("nvim-treesitter-textobjects").setup({
	select = { lookahead = true },
	move = { set_jumps = true },
})

local select = require("nvim-treesitter-textobjects.select").select_textobject
local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

local textobjects = {
	{ "aa", "@parameter.outer", "a argument" },
	{ "ac", "@class.outer", "a class" },
	{ "af", "@function.outer", "a function" },
	{ "ai", "@conditional.outer", "a if/conditional" },
	{ "al", "@loop.outer", "a loop" },
	{ "ia", "@parameter.inner", "inner argument" },
	{ "ic", "@class.inner", "inner class" },
	{ "if", "@function.inner", "inner function" },
	{ "ii", "@conditional.inner", "inner if/conditional" },
	{ "il", "@loop.inner", "inner loop" },
}

for _, obj in ipairs(textobjects) do
	local key, query, desc = obj[1], obj[2], obj[3]
	vim.keymap.set({ "x", "o" }, key, function()
		select(query, "textobjects")
	end, { desc = desc })
end

local movements = {
	{ "[a", "@parameter.outer", "prev argument" },
	{ "[f", "@function.outer", "prev function" },
	{ "[t", "@class.outer", "prev class/type" },
	{ "]a", "@parameter.outer", "next argument" },
	{ "]f", "@function.outer", "next function" },
	{ "]t", "@class.outer", "next class/type" },
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
