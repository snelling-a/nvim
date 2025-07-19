vim.cmd.runtime({
	args = { "syntax/handlebars.lua" },
	bang = true,
})
vim.cmd.runtime({
	args = { "syntax/html.vim" },
	bang = true,
})
vim.opt_local.iskeyword:append("-")

local tags = {
	"mj-accordion",
	"mj-attributes",
	"mj-body",
	"mj-breakpoint",
	"mj-button",
	"mj-carousel",
	"mj-chart",
	"mj-column",
	"mj-divider",
	"mj-font",
	"mj-group",
	"mj-head",
	"mj-hero",
	"mj-html-attributes",
	"mj-image",
	"mj-include",
	"mj-navbar",
	"mj-preview",
	"mj-qr-code",
	"mj-raw",
	"mj-section",
	"mj-social",
	"mj-spacer",
	"mj-style",
	"mj-table",
	"mj-text",
	"mj-title",
	"mj-wrapper",
	"mjml",
	"mjml-msobutton",
}

for _, tag in ipairs(tags) do
	vim.cmd(("syntax keyword htmlTagName contained %s"):format(tag))
end
