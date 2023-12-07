if exists('current_compiler')
finish
endif
let current_compiler = 'eslint_d'

if exists(':CompilerSet') != 2  " older Vim always used :setlocal
command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=eslint_d\ --format\ stylish\ --ext\ .js,.jsx\ --ignore-path\ .eslintignore\ .
CompilerSet errorformat=%-P%f,
        \%\\s%#%l:%c\ %#\ %trror\ \ %m,
        \%\\s%#%l:%c\ %#\ %tarning\ \ %m,
        \%-Q,
        \%-G%.%#,
