local containedin_groups = { "htmlBold", "htmlItalic", "htmlTagName", "htmlArg", "htmlEndTag", "html" }

vim.cmd(
	([[ syntax region handlebarsBlock start=/{{/ end=/}}/ keepend containedin=%s ]]):format(
		table.concat(containedin_groups, ",")
	)
)
vim.api.nvim_set_hl(0, "handlebarsBlock", { link = "TSTagDelimiter", default = true })

vim.cmd([[ syntax keyword handlebarsConditional contained containedin=handlebarsBlock if else unless with ]])
vim.api.nvim_set_hl(0, "handlebarsConditional", { link = "Conditional", default = true })

vim.cmd([[ syntax keyword handlebarsRepeat contained containedin=handlebarsBlock each for ]])
vim.api.nvim_set_hl(0, "handlebarsRepeat", { link = "Repeat", default = true })

vim.cmd([[ syntax keyword handlebarsKeyword contained containedin=handlebarsBlock log lookup this ]])
vim.api.nvim_set_hl(0, "handlebarsKeyword", { link = "Keyword", default = true })

vim.cmd([[ syntax match handlebarsVariable /\w\+\(\.\w\+\)*/ contained containedin=handlebarsBlock ]])
vim.api.nvim_set_hl(0, "handlebarsVariable", { link = "Identifier", default = true })

vim.cmd([[ syntax match handlebarsComment /{{!.\{-}}}/ contained containedin=handlebarsBlock ]])
vim.api.nvim_set_hl(0, "handlebarsComment", { link = "Comment", default = true })

vim.cmd([[ syntax match handlebarsString /"[^"]\{-}"/ contained containedin=handlebarsBlock ]])
vim.api.nvim_set_hl(0, "handlebarsString", { link = "String", default = true })

vim.cmd([[ syntax match handlebarsStringSingle /'[^']\{-}'/ contained containedin=handlebarsBlock ]])
vim.api.nvim_set_hl(0, "handlebarsStringSingle", { link = "String", default = true })
