require("impatient").enable_profile()
require("user")

if vim.g.vscode then
	require("vscode")
else
	require("user")
end
