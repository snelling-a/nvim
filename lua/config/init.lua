require("config.keymap")

require("config.lazy")

require("config.abbrev")
require("config.autocmd")
require("config.command")
require("config.opt")
require("config.ui")
-- require("config.util.netrw")

vim.cmd([[packadd cfilter]])
if vim.fn.executable("fzf") == 1 then
	-- [[set rtp+=/usr/local/opt/fzf]]
	vim.opt.rtp:append("/usr/local/opt/fzf")
end
