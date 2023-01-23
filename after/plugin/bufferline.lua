require('bufferline').setup {
    options = {
        right_mouse_command = ":BufferLineTogglePin",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_ --[[ count ]] , level, _ --[[ diagnostics_dict ]] , _ --[[ context ]])
            local icon = level:match("error") and "" or ""
            return " " .. icon
        end,
       custom_filter = function(buf_number, _ --[[ buf_numbers ]])
           if vim.bo[buf_number].filetype ~= "fugitive" then
               return true
           end
       end,
        offsets = {
            {
                filetype = "packer",
                text = "Packer",
                text_align = "left",
                separator = true
            },
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
                separator = true
            },
            { filetype = "undotree",
                text = "Undotree",
                text_align = "left",
                separator = true
            },
        },
        groups = {
            options = {
                toggle_hidden_on_enter = true
            },
            items = {
                require('bufferline.groups').builtin.pinned:with({ icon = "" }),
                {
                    name = "Tests",
                    highlight = { underline = true, sp = "blue" },
                    priority = 2,
                    icon = "",
                    matcher = function(buf)
                        return buf.filename:match('%_test') or buf.filename:match('%_spec')
                    end,
                },
                {
                    name = "Docs",
                    highlight = { undercurl = true, sp = "green" },
                    auto_close = false,
                    matcher = function(buf)
                        return buf.filename:match('%.md') or buf.filename:match('%.txt')
                    end,
                    separator = {
                        style = require('bufferline.groups').separator.tab
                    },
                }
            }
        }
    }
}
