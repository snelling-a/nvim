" Replace | with │ in tree view using concealing
syntax match netrwTreeBarPipe /\(^\([-+|] \)*\)\@<=| \@=/ conceal cchar=│

setlocal conceallevel=2
setlocal concealcursor=nvic

highlight link netrwTreeBarPipe netrwTreeBar
