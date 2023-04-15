vim.loader.enable()

local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
	impatient.enable_profile()
end

if vim.g.vscode then
	require("vscode")
else
	require("user")
	require("ui")
end
