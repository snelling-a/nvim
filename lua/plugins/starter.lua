---@type LazySpec
return {
	"nvim-mini/mini.starter",
	event = { "VimEnter" },
	config = function()
		local function new_section(name, action, section)
			return { name = name, action = action, section = section }
		end

		local starter = require("mini.starter")
		local Icons = require("icons")

		starter.setup({
			evaluate_single = true,
			header = " ▌║█║▌│║▌│║▌║▌█║   "
				.. Icons.misc.neovim
				.. "eo"
				.. Icons.servers.vimls
				.. "im "
				.. "   ▌│║▌║▌│║║▌█║▌║█ ",
			footer = " ",
			items = {
				new_section("Find file", "Pick files", "Pick"),
				new_section("Grep", "Pick grep_live", "Pick"),
				new_section("Lazy", "Lazy", "Config"),
				new_section("Mason", "Mason", "Config"),
				new_section("Quit", "qa", "Built-in"),
				new_section("SessionLoad", "SessionLoad", "Sessions"),
				starter.sections.recent_files(5, true, true),
			},
			content_hooks = {
				starter.gen_hook.adding_bullet("░ ", true),
				starter.gen_hook.aligning("center", "center"),
			},
		})
	end,
}
