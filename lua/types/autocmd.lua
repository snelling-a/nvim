---@meta

---@class vim.api.keyset.create_autocmd.opts.callback.event
---@field id number autocommand id
---@field event string name of the triggered event |autocmd-events|
---@field group number|nil autocommand group id, if any
---@field match string expanded value of |<amatch>|
---@field buf number expanded value of |<abuf>|
---@field file string expanded value of |<afile>|
---@field data any data passed from |nvim_exec_autocmds(|

---@alias vim.api.keyset.create_autocmd.opts vim.api.keyset.create_autocmd|{callback: fun(event: vim.api.keyset.create_autocmd.opts.callback.event): any}

---@alias MiniFiles.autocmd.event vim.api.keyset.create_autocmd.opts.callback.event|{data: {buf_id: integer}}
