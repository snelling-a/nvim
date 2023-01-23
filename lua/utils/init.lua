local get_map_options = function(custom_options)
    local options = { silent = true }
    if custom_options then
        options = vim.tbl_extend("force", options, custom_options)
    end
    return options
end

local utils = {}

utils.map = function(mode, target, source, opts)
    vim.keymap.set(mode, target, source, get_map_options(opts))
end

for _, mode in ipairs({ "n", "o", "i", "x", "t", "c", "v" }) do
    utils[mode .. "map"] = function(...)
        utils.map(mode, ...)
    end
end

function utils.reload_modules()
    local config_path = vim.fn.stdpath "config"
    local lua_files = vim.fn.glob(config_path .. "**/*.lua", 0, 1)

    for _, file in ipairs(lua_files) do
        local module_name = string.gsub(file, ".*/(.*)/(.*).lua", "%1.%2")
        vim.pretty_print(module_name)
        package.loaded[module_name] = nil
    end
    vim.cmd [[source $MYVIMRC]]
    vim.notify "Reloaded all config modules"
end

return utils
