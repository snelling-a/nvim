---@type LazySpec
return {
	"echasnovski/mini.icons",
	config = function()
		local icons = require("mini.icons")

		icons.setup({
			file = {
				[".babelrc"] = { glyph = Config.icons.javascript.babel, hl = "MiniIconsYellow" },
				[".eslintignore"] = { glyph = Config.icons.servers.eslint, hl = "MiniIconsYellow" },
				[".eslintrc.js"] = { glyph = Config.icons.servers.eslint, hl = "MiniIconsYellow" },
				[".eslintrc.json"] = { glyph = Config.icons.servers.eslint, hl = "MiniIconsYellow" },
				[".node-version"] = { glyph = Config.icons.javascript.node, hl = "MiniIconsGreen" },
				[".prettierignore"] = { glyph = Config.icons.javascript.prettier, hl = "MiniIconsPurple" },
				[".prettierrc"] = { glyph = Config.icons.javascript.prettier, hl = "MiniIconsPurple" },
				[".prettierrc.json"] = { glyph = Config.icons.javascript.prettier, hl = "MiniIconsPurple" },
				[".yarnrc.yml"] = { glyph = Config.icons.javascript.yarn, hl = "MiniIconsBlue" },
				["eslint.config.js"] = { glyph = Config.icons.servers.eslint, hl = "MiniIconsYellow" },
				["package-lock.json"] = { glyph = Config.icons.javascript.node, hl = "MiniIconsGreen" },
				["package.json"] = { glyph = Config.icons.javascript.node, hl = "MiniIconsGreen" },
				["tsconfig.build.json"] = { glyph = Config.icons.servers.ts, hl = "MiniIconsAzure" },
				[".keep"] = { glyph = Config.icons.git.git, hl = "MiniIconsGrey" },
				["tsconfig.json"] = { glyph = Config.icons.servers.ts, hl = "MiniIconsAzure" },
				["yarn.lock"] = { glyph = Config.icons.javascript.yarn, hl = "MiniIconsBlue" },
			},
		})

		icons.mock_nvim_web_devicons()
	end,
}
