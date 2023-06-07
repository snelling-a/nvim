vim.loader.enable()

if vim.g.vscode then
	require("vscode")
else
	require("config")
end
