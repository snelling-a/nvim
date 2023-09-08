;; extends

(_) @spell

((tag
   (name) @text.todo
   ":" @punctuation.delimiter)
 (#eq? @text.todo "TODO"))

((tag
   (name) @text.note
   ":" @punctuation.delimiter)
 (#any-of? @text.note "NOTE" "XXX"))

((tag
   (name) @text.warning
   ":" @punctuation.delimiter)
 (#any-of? @text.warning "HACK" "WARNING" "SAFETY" "PERF"))

((tag
   (name) @text.danger
   ":" @punctuation.delimiter)
 (#any-of? @text.danger "FIXME" "BUG" "DANGER"))
