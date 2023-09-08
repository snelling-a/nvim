;; extends

; example:
;   vim.cmd (([[ highlight @text.todo ctermbg=NONE guibg=NONE guifg='%s' ]]):format(require'user.config'.colors.hint))
((function_call
   name: (_) @vim_cmd_call
   arguments: (arguments
                (function_call
                  name: (method_index_expression
                          table: (parenthesized_expression
                                   (string
                                     content: _ @vim))))))
 (#any-of? @vim_cmd_call "vim.cmd"))
