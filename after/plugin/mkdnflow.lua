local icons = require("ui.icons").progress

local mappings = {
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
}

require("mkdnflow").setup({
	links = { conceal = true, name_is_source = true },
	mappings = mappings,
	to_do = { symbols = { " ", icons.pending, "x" } },
})
