vim.filetype.add({
	pattern = {
		["%.?ignore.*"] = "gitignore",
		["%.env%.[%w_.-]+"] = "sh",
		[".*%.log"] = "log",
		["*.pcss"] = "css",
		[".*/%.?git/attributes"] = "gitattributes",
		[".*/%.?git/ignore"] = "gitignore",
		[".*/kitty/.+%.conf"] = "bash",
		[".*/tmux/.+%.conf"] = "tmux",
		[".*/%.github/.*%.y*ml"] = "yaml.github",
		["compose.y.?ml"] = "yaml.docker-compose",
		["docker%-compose%.y.?ml"] = "yaml.docker-compose",
		[".*%.?conf(ig)"] = function(path)
			if path:match("git") then
				return "gitconfig"
			end

			return "conf"
		end,
	},
	extension = { mjml = "mjml" },
	filename = { Brewfile = "ruby", known_hosts = "sshknownhosts" },
})
