-- vim: foldmethod=marker: foldlevel=0: foldlevelstart=0
---@meta types

--- AUTOCOMD {{{
---@class Ev
---@field id number autocommand id
---@field event string name of the triggered event |autocmd-events|
---@field group number|nil autocommand group id, if any
---@field match string expanded value of |<amatch>|
---@field buf number expanded value of |<abuf>|
---@field file string expanded value of |<afile>|
---@field data any data passed from |nvim_exec_autocmds(|
--- }}}

-- COMMAND {{{
---@class Context
---@field name? string Command name
---@field args? string The args passed to the command, if any <args>
---@field fargs? table The args split by unescaped whitespace (when more than one argument is allowed), if any <f-args>
---@field nargs? string Number of arguments command-nargs
---@field bang? boolean "true" if the command was executed with a ! modifier <bang>
---@field line1? number The starting line of the command range <line1>
---@field line2? number The final line of the command range <line2>
---@field range? number The number of items in the command range 0, 1, or 2 <range>
---@field count? number Any count supplied <count>
---@field reg? string The optional register, if specified <reg>
---@field mods? string Command modifiers, if any <mods>
---@field smods? table Command modifiers in a structured format. Has the same structure as the "mods" key of nvim_parse_cmd().

---@alias Opts Context
-- }}}

-- KEYMAP {{{
---@class Keymap: keymap.util
---@field unimpaired Unimpaired
---@field center keymap.center_actions
---@field leader Leader

---@alias Description {base: string, text: LeftRight}
---@alias LeftRight {right: string|function, left: string|function}
---@alias map fun(lhs: string, rhs: string|fun(...: any): (...: any), opts?: table)
---@alias ModeString "c"|"i"|"n"|"o"|"t"|"v"|"x"
---@alias VimMode ModeString|table<ModeString> Mode short-name, see |nvim_set_keymap()|.

---@alias UnimpairedText {right: string|function, left: string|function}
--- replacement for vim-unimpaired
--- creates 2 keymaps starting with `"["` and `"]"`
---@alias Unimpaired fun(lhs: string, rhs: { right: string|function, left: string|function}, desc: { base: string, text: UnimpairedText}, opts?: table)

--- Wrapper around Util.map using the <leader> in lhs
--- default mode is 'n'
---@alias Leader fun(lhs: string, rhs: string|fun(...: any): (...: any), opts?: table, mode?: VimMode)

---@class LspKeymap: LazyKeys
---@field buffer? integer
---@field has? string
---@field silent? boolean
--- }}}

-- LOGGER {{{
---@alias Message string|string[]
---@alias Title string?
---@alias Level 0|1|2|3|4|5

---@alias NotifyArgs {msg: Message, title?: Title, once?: boolean}|Message
---@alias Args Message|NotifyArgs|{msg: Message, title?: string}
---@alias ConfirmArgs {msg: Message, choices: string, default: number, type: string}?

---@class UiOpts
---@field prompt? string|nil
---@field format_item? function(item: T): string
---@field kind? string

---@alias OnChoice function(item?: T, idx?: number)

---@class Logger
---@field title Title
---@field new fun(self: Logger, title: Title): Logger
---@field private log fun(self: Logger, level: integer, args: NotifyArgs|Message)
---@field private get_logger_args fun(args: Args): string, Title
---@field info fun(self: Logger, args: NotifyArgs)
---@field warn fun(self: Logger, args: NotifyArgs)
---@field error fun(self: Logger, args: NotifyArgs, code: integer|string?)
---@field confirm fun(self: Logger, confirm_args: ConfirmArgs): number|nil confirmation
---@field select fun(self: Logger, items: string|string[], ui_opts?: UiOpts, on_choice: OnChoice)
---@field lazy_notfy fun()

-- }}}

-- LSP {{{
---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?: fun(client: lsp.Client): boolean}
---@alias lsp.Client.format {timeout_ms?: number, format_options?: table} | lsp.Client.filter
---@alias SetupLanguageParam string|string[]?
---@alias SetupLanguageArgs {server: string?, server_opts:table?, langs: SetupLanguageParam, formatters: SetupLanguageParam, linters: SetupLanguageParam, ts: SetupLanguageParam}
---@alias Servers table<string, lspconfig.Config>
---@alias DiagnosticLhs "d"|"e"|"w"
---@alias DiagnosticText "[d]iagnostic"|"[e]rror"|"[w]arning"
---@alias DiagnosticSpec {text: DiagnosticText, severity: lsp.DiagnosticSeverity|nil}
---@alias UnimpairedSpec table<DiagnosticLhs,DiagnosticSpec>

---@class LSP
---@field format lsp.format
---@field highlight lsp.highlight
---@field keymap lsp.keymap
---@field logger Logger
---@field mason Mason
---@field opts lsp.opts
---@field rename lsp.rename
---@field servers Servers
---@field util lsp.util

---@class Formatter
---@field name string
---@field primary? boolean
---@field format fun(bufnr: number)
---@field sources fun(bufnr: number): string[]
---@field priority number

-- }}}

-- PLUGINS {{{
---@alias MasonOpts MasonSettings|{ensure_installed: string[]}
---@alias RosePineOptions Options
-- }}}

-- TERMINAL {{{
---@alias TermArgs TermCreateArgs|{shell: string}
-- }}}

-- UI {{{
---@class UI
---@field icons ui.icons

---@alias E {bufnr: integer, col: integer, lnum: integer, text: string, type: string, valid: integer}
---@alias Sign {name: string, text: string, texthl: string, priority: number}

---@alias What
---| "fg" foreground color (GUI: color name used to set the color, cterm: color number as string, term: empty string)
---| "bg" background color (as with "fg")
---| "font" font name (only available in the GUI) |highlight-font|
---| "sp" special color (as with "fg") |guisp|
---| "fg#" like "fg", but for the GUI and the GUI is running the name in "#RRGGBB" form
---| "bg#" like "fg#" for "bg"
---| "sp#" like "fg#" for "sp"
---| "bold" "1" if bold
---| "italic" "1" if italic
---| "reverse" "1" if reverse
---| "inverse" "1" if inverse (= reverse)
---| "standout" "1" if standout
---| "underline" "1" if underlined
---| "undercurl" "1" if undercurled
---| "underdouble" "1" if double underlined
---| "underdotted" "1" if dotted underlined
---| "underdashed" "1" if dashed underlined
---| "strikethrough" "1" if struckthrough
---| "altfont" "1" if alternative font
---| "nocombine" "1" if nocombine
--}}}

-- UTIL {{{
---@class Util
---@field constants util.constants
---@field toggle util.toggle
-- }}}
