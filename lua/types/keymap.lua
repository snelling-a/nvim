---@meta

---@alias Keymap.mode
---| '"n"'  # normal
---| '"v"'  # visual and select
---| '"o"'  # operator-pending
---| '"i"'  # insert
---| '"c"'  # cmdline
---| '"s"'  # select
---| '"x"'  # visual
---| '"l"'  # langmap
---| '"t"'  # terminal
---| '"ca"' # command abbreviation
---| '"ia"' # insert abbreviation
---| '"!a"' # command and insert abbreviation
---| '"!"'  # insert and cmd-line
---| '""'   # normal, visual, and operator-pending

---@alias vim.keymap.set.Mode Keymap.mode|table<Keymap.mode>
---@alias vim.keymap.set.function fun(mode: vim.keymap.set.Mode, lhs: string, rhs: string|function, opts?: vim.api.keyset.keymap): nil

---@alias map fun(lhs: string, rhs: string|fun(...: any): (...: any), opts?: table)
---@alias ModeString "c"|"i"|"n"|"o"|"t"|"v"|"x"
---@alias VimMode ModeString|table<ModeString> Mode short-name, see |nvim_set_keymap()|.
