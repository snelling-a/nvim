(_) @spell

((tag
   (name) @text.todo 
   ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
   ":" @punctuation.delimiter)
 (#eq? @text.todo "TODO"))

((tag
   (name) @text.note 
   ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
   ":" @punctuation.delimiter)
 (#any-of? @text.note "NOTE" "XXX"))

((tag
   (name) @text.warning 
   ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
   ":" @punctuation.delimiter)
 (#any-of? @text.warning "HACK" "WARNING" "SAFETY" "PERF"))

((tag
   (name) @text.danger 
   ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
   ":" @punctuation.delimiter)
 (#any-of? @text.danger "FIXME" "BUG" "DANGER"))

; Issue number (#123)
("text" @number
 (#lua-match? @number "^#[0-9]+$"))

; User mention (@user)
("text" @constant 
 (#lua-match? @constant "^[@][a-zA-Z0-9_-]+$")
 (#set! "priority" 95))
