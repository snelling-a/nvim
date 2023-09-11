if not vim.g.vscode then
	return
end

require("config.keymap")
require("config.opt")

local Util = require("config.util")

local opt = vim.opt

opt.inccommand = "split"
opt.splitbelow = true
opt.splitright = true

local function vscode(vs_action)
	return function() require("vscode-neovim").notify(vs_action, {}) end
end

local function vscode_go_to_definition(str)
	if vim.fn.exists(vim.b.vscode_controlled) and vim.b.vscode_controlled then
		return vscode("editor.action." .. str)
	else
		return vim.cmd([[normal! \<C-]>]])
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
map("<Leader>ca", "codeAction")
map("<Leader>hp", "dirtydiff.next")
map("<Leader>hr", "git.revertSelectedRanges")
map("<Leader>hs", "git.stageSelectedRanges")
map("<Leader>hu", "git.unstageSelectedRanges")
map("<leader>rn", "rename")
map("<leader>sf", "workbench.action.quickOpen")
map("<leader>w", "workbench.action.files.save")
map("[c", "workbench.action.editor.previousChange")
map("[d", "marker.prevInFiles")
map("]c", "workbench.action.editor.nextChange")
map("]d", "marker.nextInFiles")
map("fs", "workbench.action.gotoSymbol", { "n", "x" })
map("gd", "peekDefinition", { "n", "x" })
map("gI", "peekImplementation")
map("gr", "referenceSearch.trigger", { "n", "x" })
map("gx", "openLink")
map("K", "showHover", { "n", "x" })
map("za", "editor.toggleFold")
map("zA", "editor.unfoldRecursively")
map("zm", "editor.foldAll")
map("zn", "editor.unfoldAll")
