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
	".git",
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
	local css = find(root, [[-type f -name '*.css' -exec grep -l '@import "tailwindcss"' {} +]])
	local configs = find(root, "-type f \\( " .. names .. " \\)")
	---@type table<string, boolean>
	local globs = {}
	for _, config in ipairs(configs) do
		local rel = vim.fs.relpath(root, vim.fs.dirname(config))
		if rel then
			globs[rel .. "/**"] = true
		end
	end
	local glob_list = vim.tbl_keys(globs)
	if #css == 0 or #glob_list == 0 then
		return
	end
	if #css == 1 then
		return { [vim.fs.relpath(root, css[1]) or css[1]] = glob_list }
	end
	---@type TailwindConfigMap
	local map = {}
	for _, path in ipairs(css) do
		map[vim.fs.relpath(root, path) or path] = {
			(vim.fs.relpath(root, vim.fs.dirname(path)) or vim.fs.dirname(path)) .. "/**",
		}
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
		config.settings = vim.tbl_deep_extend("keep", config.settings or {}, {
			editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
		})
		local root = config.root_dir
		if type(root) ~= "string" then
			return
		end
		local config_file = load(root)
		if config_file then
			config.settings = vim.tbl_deep_extend("keep", config.settings, {
				tailwindCSS = { experimental = { configFile = config_file } },
			})
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
	workspace_required = true,
}
