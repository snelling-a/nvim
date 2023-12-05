local opt = vim.opt

local shortmess_append = {
	--  l	use "999L, 888B" instead of "999 lines, 888 bytes"
	--  m	use "[+]" instead of "[Modified]"
	--  r	use "[RO]" instead of "[readonly]"
	--  w	use "[w]" instead of "written" for file write message and "[a]" instead of "appended" for ':w >> file' command
	"A", -- don't give the "ATTENTION" message when an existing swap file is found
	"a", --  all of the above abbreviations
	"c", --  don't give ins-completion-menu messages
	"F", -- don't give the file info when editing a file, like `:silent` was used for the command
	"I", --  don't give the intro message when starting Vim
	"o", -- overwrite message for writing a file with subsequent message for reading a file
	"q", --  use "recording" instead of "recording @a"
	"s", --  don't give "search hit BOTTOM/TOP, continuing at TOP/BOTTOM" messages; "W" after the count message
	"t", -- truncate file message at the start if it is too long to fit on the command-line
	"W", --	don't give "written" or "[w]" when writing a file
}

local shortmess_remove = {
	"O", -- message for reading a file overwrites any previous message; also for quickfix message (e.g., ":cn")
	"T", -- Truncate other messages in the middle if they are too long to fit on the command line
	"C", --  don't give |ins-completion-menu| messages
	"S", --  do not show search count message when searching, e.g. "[1/5]"
}

for _, flag in ipairs(shortmess_append) do
	opt.shortmess:append(flag)
end
for _, flag in ipairs(shortmess_remove) do
	opt.shortmess:remove(flag)
end
