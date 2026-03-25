vim.loader.enable()
require("options")
require("autocmds")
require("commands")
require("keymaps")

if vim.g.vscode then
	require("vscode-keymaps")
else
	require("plugins")
end
