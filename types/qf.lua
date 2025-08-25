-- luacheck: ignore 631 (line is too long)

---@class qflist
---@field changedtick	integer get the total number of changes made to the list |quickfix-changedtick|
---@field context	any get the |quickfix-context|
---@field efm string	errorformat to use when parsing "lines". If not present, then the 'errorformat' option value is used.
---@field id integer	get information for the quickfix list with |quickfix-ID|; zero means the id for the current list or the list specified by "nr"
---@field idx	integer get information for the quickfix entry at this index in the list specified by "id" or "nr". If set to zero, then uses the current entry. See |quickfix-index|
---@field items qf.item[]	quickfix list entries
---@field lines string[]	parse a list of lines using 'efm' and return the resulting entries.  Only a |List| type is accepted.  The current quickfix list is not modified. See |quickfix-parse|.
---@field nr 0|"$"	get information for this quickfix list; zero means the current quickfix list and "$" means the last quickfix list
---@field qfbufnr integer number of the buffer displayed in the quickfix window. Returns 0 if the quickfix buffer is not present. See |quickfix-buffer|.
---@field size integer	number of entries in the quickfix list
---@field title string	get the list title |quickfix-title|
---@field winid integer	get the quickfix |window-ID|
---@field all any	all of the above quickfix properties

---@class QFTFInfo
---@field quickfix number
---@field winid number
---@field id number
---@field start_idx number
---@field end_idx number

---@class qf.item.user_data
---@field range {start: {line: number, character: number}, end: {line: number, character: number}}
---@field uri string

---@class qf.item
---@field bufnr number
---@field col number
---@field end_col number
---@field end_lnum number
---@field lnum number
---@field module string
---@field nr number
---@field pattern string
---@field text string
---@field type string
---@field user_data qf.item.user_data
---@field valid number
---@field vcol number

---@class QFLine
---@field col string
---@field filename string
---@field lnum string
---@field text string
---@field type string

---@alias QFHL {group: string, line: integer, col: integer, end_col: integer}
