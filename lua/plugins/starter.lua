---@type LazySpec
return {
	"echasnovski/mini.starter",
	event = { "VimEnter" },
	config = function()
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			Config.autocmd.create_autocmd("User", {
				callback = function()
					require("lazy").show()
				end,
				pattern = "MiniStarterOpened",
				group = "MiniStarter",
			})
		end

		local function new_section(name, action, section)
			return { name = name, action = action, section = section }
		end

		local starter = require("mini.starter")

		starter.setup({
			evaluate_single = true,
			header = " ▌║█║▌│║▌│║▌║▌█║   "
				.. Config.icons.misc.neovim
				.. "eo"
				.. Config.icons.misc.vim
				.. "im "
				.. "   ▌│║▌║▌│║║▌█║▌║█ ",
			footer = " ",
			items = {
				new_section("Find file", "FzfLua files", "FzfLua"),
				new_section("Lazy", "Lazy", "Config"),
				new_section("Grep", "FzfLua live_grep", "FzfLua"),
				new_section("Quit", "qa", "Built-in"),
				new_section("Recent files", "FzfLua oldfiles", "FzfLua"),
				new_section("SessionLoad", "SessionLoad", "Sessions"),
				starter.sections.recent_files(5, true, true),
			},
			content_hooks = {
				starter.gen_hook.adding_bullet("░ ", false),
				starter.gen_hook.aligning("center", "center"),
			},
		})
	end,
}
