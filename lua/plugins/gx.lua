local Gx = { "chrishrb/gx.nvim" }

Gx.config = true

Gx.dependencies = { "nvim-lua/plenary.nvim" }

Gx.event = { "BufEnter" }

Gx.opts = {
	handler_options = {
		search_engine = "ecosia",
	},
}

return Gx
