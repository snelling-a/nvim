local file_types = { "markdown", "copilot-chat" }

---@type LazySpec
return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
	enabled = false,
	ft = file_types,
	config = function()
		require("render-markdown").setup({
			latex = { enabled = false },
			preset = "obsidian",
			code = { right_pad = 1, sign = false, width = "block" },
			file_types = file_types,
			heading = {
				sign = false,
			},
			overrides = {
				buftype = {
					nofile = {
						code = { style = "normal" },
					},
				},
			},
		})
	end,
}
