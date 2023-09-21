require("config.keymap")

require("config.lazy")

require("config.abbrev")
require("config.autocmd")
require("config.command")
require("config.opt")
require("config.ui")

vim.cmd([[packadd cfilter]])
if vim.fn.executable("fzf") == 1 then
	vim.opt.rtp:append("/usr/local/opt/fzf")
end
