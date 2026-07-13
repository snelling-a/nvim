local PRUNE = "-name node_modules -o -name .git -o -name dist -o -name .next -o -name .turbo"
local ROOT_MARKERS = {
	"tailwind.config.js",
	"tailwind.config.cjs",
	"tailwind.config.mjs",
	"tailwind.config.ts",
	"postcss.config.js",
	"postcss.config.cjs",
	"postcss.config.mjs",
	"postcss.config.ts",
}
---@param name string
---@return boolean
local CONFIGS = vim.tbl_filter(function(name)
	return name:match("^tailwind%.config%.") ~= nil
end, ROOT_MARKERS)
local CACHE = vim.fs.joinpath(vim.fn.stdpath("cache"), "tailwindcss-language-server")

---@alias TailwindConfigMap table<string, string[]>

---@type table<string, TailwindConfigMap|false>
local mem = {}
---@type table<string, boolean>
local pending = {}

---@param root string
---@return uv.fs_stat.result|nil
local function workspace(root)
	return vim.uv.fs_stat(vim.fs.joinpath(root, "pnpm-workspace.yaml"))
end

---@param root string
---@param expr string
---@return string[]
local function find(root, expr)
	local out = vim.fn.system(
		string.format("find %s \\( %s \\) -prune -o %s -print 2>/dev/null", vim.fn.shellescape(root), PRUNE, expr)
	)
	return out == "" and {} or vim.split(vim.trim(out), "\n", { plain = true })
end

---@param root string
---@return TailwindConfigMap|nil
local function build(root)
	if not workspace(root) then
		return
	end
	local names = table.concat(
		---@param n string
		---@return string
		vim.tbl_map(function(n)
			return "-name " .. vim.fn.shellescape(n)
		end, CONFIGS),
		" -o "
	)
	-- grep runs in a separate step (not as a `find -exec ... {} +` action)
	-- because `find`'s trailing `-print` would otherwise fire for every file
	-- in the batch once grep matched any one of them, not just the matches
	local css_candidates = find(root, "-type f -name '*.css'")
	---@type string[]
	local css = {}
	if #css_candidates > 0 then
		local out = vim.fn.system(vim.list_extend({ "grep", "-l", '@import "tailwindcss"' }, css_candidates))
		css = out == "" and {} or vim.split(vim.trim(out), "\n", { plain = true }) --[[@as string[] ]]
	end
	local configs = find(root, "-type f \\( " .. names .. " \\)")
	if #css == 0 or #configs == 0 then
		return
	end
	---@param path string
	---@return string
	---@type string[]
	local css_rel = vim.tbl_map(function(path)
		return vim.fs.relpath(root, path) or path
	end, css)
	-- a config's directory may not be nested under the css entry it actually
	-- consumes (e.g. an app importing a shared package's globals.css), so
	-- configs unclaimed by any css entry are applied to every css entry
	---@type table<string, table<string, boolean>>
	local claimed = {}
	for _, rel in ipairs(css_rel) do
		claimed[rel] = {}
	end
	---@type table<string, boolean>
	local orphans = {}
	for _, config in ipairs(configs) do
		local config_dir = vim.fs.relpath(root, vim.fs.dirname(config))
		if config_dir then
			local glob = config_dir .. "/**"
			local owner = vim.iter(css_rel):find(function(rel)
				return vim.startswith(rel, config_dir .. "/")
			end)
			if owner then
				claimed[owner][glob] = true
			else
				orphans[glob] = true
			end
		end
	end
	---@type TailwindConfigMap
	local map = {}
	for _, rel in ipairs(css_rel) do
		map[rel] = vim.tbl_keys(vim.tbl_extend("force", claimed[rel], orphans))
	end
	return map
end

---@param root string
---@return TailwindConfigMap|nil
local function load(root)
	local stat = workspace(root)
	if not stat then
		return
	end
	local key = root .. ":" .. stat.mtime.sec
	if mem[key] ~= nil then
		return mem[key] or nil
	end
	local file = io.open(vim.fs.joinpath(CACHE, vim.fn.sha256(root) .. ".json"))
	if not file then
		return
	end
	local ok, decoded = pcall(vim.json.decode, file:read("*a"))
	file:close()
	---@type { mtime: integer, config: TailwindConfigMap }|nil
	local data = ok and decoded or nil
	if data and data.mtime == stat.mtime.sec then
		mem[key] = data.config
		return data.config
	end
end

---@param root string
---@param config TailwindConfigMap
local function save(root, config)
	local stat = workspace(root)
	if not stat then
		return
	end
	mem[root .. ":" .. stat.mtime.sec] = config
	vim.fn.mkdir(CACHE, "p")
	local file = io.open(vim.fs.joinpath(CACHE, vim.fn.sha256(root) .. ".json"), "w")
	if file then
		file:write(vim.json.encode({ mtime = stat.mtime.sec, config = config }))
		file:close()
	end
end

---@param bufnr integer
---@param root string
local function refresh(bufnr, root)
	if pending[root] or load(root) then
		return
	end
	pending[root] = true
	vim.schedule(function()
		local config = build(root)
		if config then
			save(root, config)
			for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "tailwindcss-language-server" })) do
				client:stop(true)
			end
			vim.lsp.enable("tailwindcss-language-server")
		end
		pending[root] = nil
	end)
end

---@type vim.lsp.Config
return {
	before_init = function(_, config)
		-- mutate config.settings in place rather than reassigning it: the
		-- client's `self.settings` (used for workspace/didChangeConfiguration
		-- and to answer workspace/configuration requests) is bound to this
		-- table by reference at client construction, before before_init runs,
		-- so replacing config.settings with a new table would be invisible to it
		config.settings = config.settings or {}
		local editor = (config.settings.editor or {}) --[[@as table]]
		config.settings.editor = vim.tbl_deep_extend("keep", editor, { tabSize = vim.lsp.util.get_effective_tabstop() })
		local root = config.root_dir
		if type(root) ~= "string" then
			return
		end
		local config_file = load(root)
		if config_file then
			local tailwind_css = (config.settings.tailwindCSS or {}) --[[@as table]]
			config.settings.tailwindCSS =
				vim.tbl_deep_extend("keep", tailwind_css, { experimental = { configFile = config_file } })
		end
	end,
	capabilities = {
		workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
	},
	cmd = function(dispatchers, config)
		local cmd = "tailwindcss-language-server"
		if (config or {}).root_dir then
			local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
			if vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
		end
		return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
	end,
	filetypes = {
		"astro",
		"css",
		"html",
		"javascript",
		"javascriptreact",
		"less",
		"markdown",
		"mdx",
		"postcss",
		"sass",
		"scss",
		"svelte",
		"typescript",
		"typescriptreact",
		"vue",
	},
	on_attach = function(client, bufnr)
		if type(client.config.root_dir) == "string" then
			refresh(bufnr, client.config.root_dir)
		end
	end,
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local repo = vim.fs.root(fname, { "pnpm-workspace.yaml", ".git" })
		if repo and workspace(repo) then
			on_dir(repo)
			return
		end
		local marker = vim.fs.find(ROOT_MARKERS, { path = fname, upward = true })[1]
		on_dir(marker and vim.fs.dirname(marker) or nil)
	end,
	settings = {
		tailwindCSS = { classFunctions = { "clsx" } },
	},
	root_markers = vim.list_extend({ "pnpm-workspace.yaml" }, ROOT_MARKERS),
	workspace_required = true,
}
