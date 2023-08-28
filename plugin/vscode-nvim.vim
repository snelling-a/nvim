if !exists('g:vscode')
  finish
endif

" LSP keymap settings
function! s:vscodeGoToDefinition(str)
    if exists('b:vscode_controlled') && b:vscode_controlled
        call VSCodeNotify('editor.action.' . a:str)
    else
        " Allow to function in help files
        exe "normal! \<C-]>"
    endif
endfunction

nnoremap gD <Cmd>call <SID>vscodeGoToDefinition('revealDefinition')<CR>
nnoremap gDD <Cmd>call VSCodeNotify('editor.action.peekDeclaration')<CR>
nnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
nnoremap gd <Cmd>call VSCodeNotify('editor.action.peekDefinition')<CR>
nnoremap K <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
nnoremap gdd <Cmd>call <SID>vscodeGoToDefinition('revealDeclaration')<CR>
nnoremap fs <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
nnoremap gD <Cmd>call <SID>vscodeGoToDefinition('revealDefinition')<CR>
nnoremap <leader>ca <Cmd>call VSCodeNotify('editor.action.codeAction')<CR>

xnoremap gD <Cmd>call <SID>vscodeGoToDefinition('revealDefinition')<CR>
xnoremap gDD <Cmd>call VSCodeNotify('editor.action.peekDeclaration')<CR>
xnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
xnoremap gd <Cmd>call VSCodeNotify('editor.action.peekDefinition')<CR>
xnoremap K <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
xnoremap gdd <Cmd>call <SID>vscodeGoToDefinition('revealDeclaration')<CR>
xnoremap fs <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
xnoremap gD <Cmd>call <SID>vscodeGoToDefinition('revealDefinition')<CR>

" Diagnostic jumping
nnoremap [d <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>
nnoremap ]d <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>

" Open-browser-like
nnoremap gx <Cmd>call VSCodeNotify('editor.action.openLink')<CR>

" vscode commentary
function! s:vscodeCommentary(...) abort
    if !a:0
        let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
        return 'g@'
    elseif a:0 > 1
        let [line1, line2] = [a:1, a:2]
    else
        let [line1, line2] = [line("'["), line("']")]
    endif

    call VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
endfunction
xmap gc  <SID>VSCodeCommentary
nmap gc  <SID>VSCodeCommentary
omap gc  <SID>VSCodeCommentary
nmap gcc <SID>VSCodeCommentaryLine

" Git keymap settings
nnoremap ]c <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>
nnoremap [c <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>
nnoremap <Leader>hs <Cmd>call VSCodeNotify('git.stageSelectedRanges')<CR>
nnoremap <Leader>hu <Cmd>call VSCodeNotify('git.unstageSelectedRanges')<CR>
nnoremap <Leader>hr <Cmd>call VSCodeNotify('git.revertSelectedRanges')<CR>
nnoremap <Leader>hp <Cmd>call VSCodeNotify('editor.action.dirtydiff.next')<CR>

" Window and buffer keymap settings
function! s:split(...) abort
    let direction = a:1
    let file = exists('a:2') ? a:2 : ''
    call VSCodeCall(direction ==# 'h' ? 'workbench.action.splitEditorDown' : 'workbench.action.splitEditorRight')
    if !empty(file)
        call VSCodeExtensionNotify('open-file', expand(file), 'all')
    endif
endfunction

function! s:splitNew(...)
    let file = a:2
    call s:split(a:1, empty(file) ? '__vscode_new__' : file)
endfunction

function! s:closeOtherEditors()
    call VSCodeNotify('workbench.action.closeEditorsInOtherGroups')
    call VSCodeNotify('workbench.action.closeOtherEditors')
endfunction

function! s:manageEditorHeight(...)
    let count = a:1
    let to = a:2
    for i in range(1, count ? count : 1)
        call VSCodeNotify(to ==# 'increase' ? 'workbench.action.increaseViewHeight' : 'workbench.action.decreaseViewHeight')
    endfor
endfunction

function! s:manageEditorWidth(...)
    let count = a:1
    let to = a:2
    for i in range(1, count ? count : 1)
        call VSCodeNotify(to ==# 'increase' ? 'workbench.action.increaseViewWidth' : 'workbench.action.decreaseViewWidth')
    endfor
endfunction

command! -complete=file -nargs=? Split call <SID>split('h', <q-args>)
command! -complete=file -nargs=? Vsplit call <SID>split('v', <q-args>)
command! -complete=file -nargs=? New call <SID>split('h', '__vscode_new__')
command! -complete=file -nargs=? Vnew call <SID>split('v', '__vscode_new__')
command! -bang Only if <q-bang> ==# '!' | call <SID>closeOtherEditors() | else | call VSCodeNotify('workbench.action.joinAllGroups') | endif

AlterCommand sp[lit] Split
AlterCommand vs[plit] Vsplit
AlterCommand new New
AlterCommand vne[w] Vnew
AlterCommand on[ly] Only

" buffer management
nnoremap <C-t> <Cmd>call <SID>splitNew('h', '__vscode_new__')<CR>
nnoremap <C-c> <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
xnoremap <C-t> <Cmd>call <SID>splitNew('h', '__vscode_new__')<CR>
xnoremap <C-c> <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>

" window/splits management
nnoremap <C-s> <Cmd>call <SID>split('h')<CR>
nnoremap <C-v> <Cmd>call <SID>split('v')<CR>
nnoremap <C-=> <Cmd>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>
nnoremap <C-_> <Cmd>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>
nnoremap <C-+> <Cmd>call <SID>manageEditorHeight(v:count, 'increase')<CR>
nnoremap <C--> <Cmd>call <SID>manageEditorHeight(v:count, 'decrease')<CR>
nnoremap <C->> <Cmd>call <SID>manageEditorWidth(v:count, 'increase')<CR>
nnoremap <C-<> <Cmd>call <SID>manageEditorWidth(v:count, 'decrease')<CR>
nnoremap <C-o> <Cmd>call VSCodeNotify('workbench.action.joinAllGroups')<CR>

xnoremap <C-s> <Cmd>call <SID>split('h')<CR>
xnoremap <C-v> <Cmd>call <SID>split('v')<CR>
xnoremap <C-=> <Cmd>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>
xnoremap <C-_> <Cmd>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>
xnoremap <C-+> <Cmd>call <SID>manageEditorHeight(v:count, 'increase')<CR>
xnoremap <C--> <Cmd>call <SID>manageEditorHeight(v:count, 'decrease')<CR>
xnoremap <C->> <Cmd>call <SID>manageEditorWidth(v:count, 'increase')<CR>
xnoremap <C-<> <Cmd>call <SID>manageEditorWidth(v:count, 'decrease')<CR>
xnoremap <C-o> <Cmd>call VSCodeNotify('workbench.action.joinAllGroups')<CR>

" Better Navigation
nnoremap <silent> <C-j> <Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <silent> <C-j> <Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <silent> <C-k> <Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <silent> <C-k> <Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <silent> <C-h> <Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <silent> <C-h> <Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <silent> <C-l> <Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <silent> <C-l> <Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>
