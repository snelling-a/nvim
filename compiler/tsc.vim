if exists('current_compiler')
  finish
endif

let g:current_compiler = "tsc"

let s:save_cpo = &cpoptions
set cpoptions&vim

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=tsc\ --pretty\ false\ --noEmit
CompilerSet errorformat=%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m
" CompilerSet makeprg=npx\ eslint\ .\ --format\ stylish
" CompilerSet errorformat=%-P%f,\%\\s%#%l:%c\ %#\ %trror\ \ %m,\%\\s%#%l:%c\ %#\ %tarning\ \ %m,\%-Q,\%-G%.%#,

let &cpoptions = s:save_cpo
unlet s:save_cpo
