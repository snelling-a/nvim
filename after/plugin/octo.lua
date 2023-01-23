require "octo".setup({})

local ft_to_parser = require "nvim-treesitter.parsers".filetype_to_parsername
ft_to_parser.octo = "markdown"
