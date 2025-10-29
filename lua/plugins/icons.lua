---@type LazySpec
return {
	"nvim-mini/mini.icons",
	config = function()
		local icons = require("mini.icons")
		local Icons = require("icons")

		icons.setup({
			file = {
				[".babelrc"] = { glyph = Icons.javascript.babel, hl = "MiniIconsYellow" },
				["eslint.config.js"] = { glyph = Icons.servers["eslint-lsp"], hl = "MiniIconsYellow" },
				[".eslintignore"] = { glyph = Icons.servers.eslint, hl = "MiniIconsBlue" },
				[".eslintrc.js"] = { glyph = Icons.servers.eslint, hl = "MiniIconsBlue" },
				[".eslintrc.json"] = { glyph = Icons.servers.eslint, hl = "MiniIconsBlue" },
				[".keep"] = { glyph = Icons.misc.git, hl = "MiniIconsGrey" },
				[".node-version"] = { glyph = Icons.javascript.node, hl = "MiniIconsGreen" },
				["package-lock.json"] = { glyph = Icons.javascript.node, hl = "MiniIconsGreen" },
				["package.json"] = { glyph = Icons.javascript.node, hl = "MiniIconsGreen" },
				[".prettierrc"] = { glyph = Icons.javascript.prettier, hl = "MiniIconsOrange" },
				[".prettierrc.json"] = { glyph = Icons.javascript.prettier, hl = "MiniIconsOrange" },
				["tsconfig.build.json"] = { glyph = Icons.servers.ts, hl = "MiniIconsAzure" },
				["tsconfig.json"] = { glyph = Icons.servers.ts, hl = "MiniIconsAzure" },
				["yarn.lock"] = { glyph = Icons.javascript.yarn, hl = "MiniIconsBlue" },
				[".yarnrc.yml"] = { glyph = Icons.javascript.yarn, hl = "MiniIconsBlue" },
				[".go-version"] = { glyph = Icons.servers.gopls, hl = "MiniIconsBlue" },
			},
		})

		icons.mock_nvim_web_devicons()
		icons.tweak_lsp_kind("replace")
	end,
}
