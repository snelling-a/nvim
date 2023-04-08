local fast_wrap = {
	chars = { "{", "[", "(", '"', "'" },
	check_comma = true,
	end_key = "$",
	highlight = "Search",
	highlight_grey = "Comment",
	keys = "qwertyuiopzxcvbnmasdfghjkl",
	map = "<M-e>",
	pattern = [=[[%'%"%>%]%)%}%,]]=],
}

require("nvim-autopairs").setup({ fast_wrap = fast_wrap })
