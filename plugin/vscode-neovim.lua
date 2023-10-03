if not vim.g.vscode then
	return
end

local Util = require("config.util")

require("config.keymap")
require("config.opt")

local function vscode(vs_action)
	return function() require("vscode-neovim").notify(vs_action) end
end

local function vscode_go_to_definition(str)
	if vim.fn.exists(vim.b.vscode_controlled) and vim.b.vscode_controlled then
		return vscode(str)
	else
		return vim.cmd.normal({ args = { "<C-]>" }, bang = true }) --[[@as string]]
	end
end

local opts = { noremap = true, silent = false }

Util.map({ "n", "x" }, "gD", vscode_go_to_definition("revealDefinition"), opts)
Util.map({ "n", "x" }, "gDD", vscode_go_to_definition("peekDeclaration"), opts)
Util.map({ "n", "x" }, "gdd", vscode_go_to_definition("revealDeclaration"), opts)

local function map(lhs, vscode_action, mode) return Util.map((mode or "n"), lhs, vscode(vscode_action), opts) end

map("<C-h>", "workbench.action.focusLeftGroup")
map("<C-i>", "workbench.action.nextEditor")
map("<C-j>", "workbench.action.focusBelowGroup")
map("<C-k>", "workbench.action.focusAboveGroup")
map("<C-l>", "workbench.action.focusRightGroup")
map("<C-o>", "workbench.action.previousEditor")
map("<Leader>ca", "editor.action.codeAction")
map("<Leader>hp", "editor.action.dirtydiff.next")
map("<Leader>hr", "git.revertSelectedRanges")
map("<Leader>hs", "git.stageSelectedRanges")
map("<Leader>hu", "git.unstageSelectedRanges")
map("<leader>rn", "editor.action.rename")
map("<C-p>", "workbench.action.quickOpen")
map("K", "editor.action.showHover", { "n", "x" })
map("[c", "workbench.action.editor.previousChange")
map("[d", "editor.action.marker.prevInFiles")
map("]c", "workbench.action.editor.nextChange")
map("]d", "editor.action.marker.nextInFiles")
map("fs", "workbench.action.gotoSymbol", { "n", "x" })
map("gI", "editor.action.peekImplementation")
map("gd", "editor.action.peekDefinition", { "n", "x" })
map("gr", "editor.action.referenceSearch.trigger", { "n", "x" })
map("gx", "editor.action.openLink")
map("zA", "editor.unfoldRecursively")
map("za", "editor.toggleFold")
map("zm", "editor.foldAll")
map("zn", "editor.unfoldAll")
