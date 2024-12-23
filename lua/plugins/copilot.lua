---@type LazySpec
return {
	"zbirenbaum/copilot.lua",
	cmd = { "Copilot" },
	build = ":Copilot auth",
	event = { "InsertEnter" },
	-- opts = {
	-- 	filetypes = { markdown = true },
	-- 	panel = { enabled = false },
	-- 	suggestion = { auto_trigger = true },
	-- },
	config = function()
		require("copilot").setup({
			filetypes = { markdown = true },
			panel = { enabled = false },
			suggestion = { auto_trigger = true },
			copilot_node_command = Config.util.get_node_path(),
		}--[[@as copilot_config]])
	end,
}
