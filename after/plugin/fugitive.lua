local utils = require('utils');
local telescope = require('telescope.builtin');

utils.nmap("<leader>gs", vim.cmd.Git)

local Fugitive = vim.api.nvim_create_augroup("Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
    group = Fugitive,
    pattern = "*",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr }
        utils.nmap("<leader>p", function() vim.cmd.Git('push') end, opts)

        utils.nmap("<leader>P", function() vim.cmd.Git({ 'pull', '--rebase' }) end, opts)

        utils.nmap("<leader>t", function() vim.cmd.Git({ "push -u origin" }) end , opts);

        utils.nmap("<leader>gb", telescope.git_branches)
        utils.nmap("<leader>gc", telescope.git_commits)
        utils.nmap("<leader>gst", telescope.git_stash)
    end,
})
