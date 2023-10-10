--- @type LazySpec
local M = {
	"ms-jpq/coq_nvim",
}

M.branch = "coq"

M.build = ":COQdeps"

M.dependencies = {
	{
		"ms-jpq/coq.artifacts",
		branch = "artifacts",
	},
	{
		"ms-jpq/coq.thirdparty",
		branch = "3p",
	},
}

M.event = {
	"InsertEnter",
}

function M.config()
	require("coq")
	require("coq_3p")({
		{ src = "builtin/html" },
		{ src = "builtin/js" },
		{ src = "builtin/syntax" },
		{ src = "copilot", accept_key = "<C-f>" },
		{ src = "nvimlua" },
	})
end

function M.init()
	vim.g.coq_settings = {
		auto_start = true,
		clients = {
			buffers = {
				same_filetype = true,
			},
			paths = {
				path_seps = {
					".",
					require("config.util.path").get_separator(),
				},
			},
			tags = {
				enabled = false,
			},
			tmux = {
				enabled = false,
			},
			tree_sitter = {
				weight_adjust = 0.05,
			},
		},
		display = {
			ghost_text = {
				highlight_group = "TSComment",
			},
			icons = {
				mappings = require("config.ui.icons").kind_icons,
				mode = "short",
			},
			preview = {
				positions = {
					east = 2,
					north = 3,
					south = 4,
					west = 1,
				},
			},
			pum = {
				kind_context = {
					" ",
					"",
				},
				source_context = {
					"⸢",
					"⸥",
				},
			},
			statusline = {
				helo = false,
			},
		},
	}
end

return M
