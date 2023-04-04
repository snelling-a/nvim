local icons = require("utils.icons").progress

require("mkdnflow").setup({
	links = { conceal = true, name_is_source = true },
	mappings = {
		MkdnFoldSection = false,
		MkdnGoBack = { "n", "<BS>" },
		MkdnGoForward = { "n", "||" },
		MkdnMoveSource = { "n", "!!" },
		MkdnNextHeading = { "n", "]]" },
		MkdnNextLink = false,
		MkdnPrevHeading = { "n", "[[" },
		MkdnPrevLink = false,
		MkdnToggleToDo = { { "n", "v" }, "<C-d>" },
		MkdnUnfoldSection = false,
	},
	to_do = { symbols = { " ", icons.pending, icons.done } },
})
