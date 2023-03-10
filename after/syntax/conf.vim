" Add numeric highlighting to conf files numbers (including longs and complex)
syn match   confNumber	"\<0[oO]\=\o\+[Ll]\=\>"
syn match   confNumber	"\<0[xX]\x\+[Ll]\=\>"
syn match   confNumber	"\<0[bB][01]\+[Ll]\=\>"
syn match   confNumber	"\<\%([1-9]\d*\|0\)[Ll]\=\>"
syn match   confNumber	"\<\d\+[jJ]\>"
syn match   confNumber	"\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
syn match   confNumber
    \ "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="
syn match   confNumber
    \ "\%(^\|\W\)\zs\d*\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>"

hi def link confNumber		Number
