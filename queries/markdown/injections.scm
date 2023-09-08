;; extends

(fenced_code_block
  (info_string
    (language) @language)
  (#any-of? @language "tsx" "jsx" "typescriptreact" "javascriptreact")
  (code_fence_content) @injection.content
  (#set! injection.language "tsx"))
