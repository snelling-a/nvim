vim.pack.add({ { src = "https://github.com/williamboman/mason.nvim", name = "mason" } })
require("mason").setup()

local CACHE_FILE = vim.fn.stdpath("data") .. "/mason_last_update_check"
local UPDATE_INTERVAL = 86400 -- 24 hours

local function should_check_updates()
	local ok, stat = pcall(vim.uv.fs_stat, CACHE_FILE)
	if not ok or not stat then
		return true
	end
	return os.time() - stat.mtime.sec > UPDATE_INTERVAL
end

local function mark_update_checked()
	local f = io.open(CACHE_FILE, "w")
	if f then
		f:write(tostring(os.time()))
		f:close()
	end
end

local function get_lsp_servers()
	local servers = {}
	for _, path in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
		local name = vim.fs.basename(path):match("^(.*)%.lua$")
		if name then
			table.insert(servers, name)
		end
	end
	return servers
end

local function get_formatters()
	local formatters = {}
	local ok, conform = pcall(require, "conform")
	if not ok then
		return formatters
	end
	local formatters_by_ft = conform.formatters_by_ft or {}
	for _, ft_formatters in pairs(formatters_by_ft) do
		for _, name in ipairs(ft_formatters) do
			if type(name) == "string" then
				formatters[name] = true
			end
		end
	end
	return vim.tbl_keys(formatters)
end

local function get_linters()
	local linters = {}
	local ok, lint = pcall(require, "lint")
	if not ok then
		return linters
	end
	local linters_by_ft = lint.linters_by_ft or {}
	for _, ft_linters in pairs(linters_by_ft) do
		for _, name in ipairs(ft_linters) do
			if type(name) == "string" then
				linters[name] = true
			end
		end
	end
	return vim.tbl_keys(linters)
end

local function ensure_tools()
	local registry = require("mason-registry")
	local check_updates = should_check_updates()

	local tools = {}
	for _, server in ipairs(get_lsp_servers()) do
		tools[server] = true
	end
	for _, formatter in ipairs(get_formatters()) do
		tools[formatter] = true
	end
	for _, linter in ipairs(get_linters()) do
		tools[linter] = true
	end

	registry.refresh(function()
		for name in pairs(tools) do
			local ok, pkg = pcall(registry.get_package, name)
			if not ok then
				goto continue
			end

			if not pkg:is_installed() then
				vim.notify("Mason: installing " .. name, vim.log.levels.INFO)
				pkg:install():once("install:success", function()
					vim.schedule(function()
						vim.notify("Mason: " .. name .. " installed", vim.log.levels.INFO)
					end)
				end)
			elseif check_updates then
				local installed = pkg:get_installed_version()
				local latest = pkg:get_latest_version()
				if installed and latest and installed ~= latest then
					vim.notify("Mason: updating " .. name, vim.log.levels.INFO)
					pkg:install():once("install:success", function()
						vim.schedule(function()
							vim.notify("Mason: " .. name .. " updated", vim.log.levels.INFO)
						end)
					end)
				end
			end

			::continue::
		end

		if check_updates then
			mark_update_checked()
		end
	end)
end

vim.api.nvim_create_user_command("MasonEnsureInstalled", ensure_tools, {
	desc = "Ensure mason tools are installed",
})

vim.defer_fn(ensure_tools, 500)
