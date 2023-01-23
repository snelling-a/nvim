local lsp = require("lsp-zero")
local telescope = require('telescope.builtin')
local utils = require("utils")

lsp.preset("recommended")

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'sumneko_lua',
})

-- Fix Undefined global 'vim'
lsp.configure('sumneko_lua', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
end)
    local opts = { buffer = bufnr }

        utils.nmap("<leader>ca", vim.lsp.buf.code_action, opts)
        utils.nmap("gd", telescope.lsp_definitions(), opts)
        utils.nmap("K", vim.lsp.buf.hover, opts)
        utils.nmap("gi", telescope.lsp_implementations(), opts)
        utils.nmap("<leader>d", vim.diagnostic.open_float, opts)
        utils.nmap("[d", vim.diagnostic.goto_next, opts)
        utils.nmap("]d", vim.diagnostic.goto_prev, opts)
        utils.nmap("gr", telescope.lsp_references(), opts)
        utils.nmap("<leader>rn", vim.lsp.buf.rename, opts)
        utils.imap("<C-s>", vim.lsp.buf.signature_help, opts)

    utils.nmap("<leader>ws", vim.lsp.buf.workspace_symbol, opts)
lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})
