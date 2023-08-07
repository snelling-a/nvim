;; extends

(strikethrough) @htmlStrike

((emphasis_delimiter) @conceal (#set! conceal ""))

(link_text) @text.uri

([
  (code_span_delimiter)
] @conceal @text.literal (#set! conceal "")
)

