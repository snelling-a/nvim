local utils = require("utils")
require("refactoring").setup({})
-- Remaps for the refactoring operations currently offered by the plugin
utils.vmap("<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], { expr = false })
utils.vmap(
	"<leader>rf",
	[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
	{ expr = false }
)
utils.vmap("<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], { expr = false })
utils.vmap("<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], { expr = false })

-- Extract block doesn't need visual mode
utils.nmap("<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]], { expr = false })
utils.nmap("<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], { expr = false })

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
utils.nmap("<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], { expr = false })
utils.vmap(
	"<leader>rr",
	-- "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
	function() require("telescope").extensions.refactoring.refactors() end
)
