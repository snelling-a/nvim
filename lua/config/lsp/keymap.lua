local Logger = require("config.util.logger")
local bind = require("config.lsp.util").bind
local Util = require("config.util")

local lsp = vim.lsp.buf
local vim_diagnostic = vim.diagnostic

local M = {}

--- @param bufnr integer
function M.on_attach(bufnr)
    Util.mapL("d", vim_diagnostic.open_float, {
        desc = "Open [d]iagnostic float",
    })
    Util.nmap("[d", function()
        vim_diagnostic.goto_prev({
            float = false,
        })
        Util.scroll_center()
    end, {
        desc = "Goto previous [d]iagnostic issue",
    })
    Util.nmap("]d", function()
        vim_diagnostic.goto_next({
            float = false,
        })
        Util.scroll_center()
    end, {
        desc = "Goto next [d]iagnostic issue",
    })

	bind(bufnr, "<leader>ca", lsp.code_action, "[C]ode [a]ction")
	bind(bufnr, "<C-g>", lsp.signature_help, "Show signature help")
	bind(bufnr, "<leader>rn", lsp.rename, "[R]ename variable")
	bind(bufnr, "K", lsp.hover, "Show hover")
	bind(bufnr, "gd", function()
		lsp.definition()
		Util.scroll_center()
	end, "Show [d]efinition")
	bind(bufnr, "gr", function()
		lsp.references({
			includeDeclaration = false,
		})
		Util.scroll_center()
	end, "[G]et [r]eferences")
	bind(bufnr, "gY", lsp.type_definition, "Show t[y]pe definition")
	bind(bufnr, "gI", lsp.implementation, "Show [i]mplementation")
end

return M
