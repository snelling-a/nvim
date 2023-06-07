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

nnoremap <leader>D <Cmd>call <SID>vscodeGoToDefinition('revealDefinition')<CR>
nnoremap gDD <Cmd>call VSCodeNotify('editor.action.peekDeclaration')<CR>
nnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
nnoremap gd <Cmd>call VSCodeNotify('editor.action.peekDefinition')<CR>
nnoremap K <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
nnoremap gD <Cmd>call <SID>vscodeGoToDefinition('revealDeclaration')<CR>
nnoremap fs <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
nnoremap gD <Cmd>call <SID>vscodeGoToDefinition('revealDefinition')<CR>

xnoremap <leader>D <Cmd>call <SID>vscodeGoToDefinition('revealDefinition')<CR>
xnoremap gDD <Cmd>call VSCodeNotify('editor.action.peekDeclaration')<CR>
xnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
xnoremap gd <Cmd>call VSCodeNotify('editor.action.peekDefinition')<CR>
xnoremap K <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
xnoremap gD <Cmd>call <SID>vscodeGoToDefinition('revealDeclaration')<CR>
xnoremap fs <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
xnoremap gD <Cmd>call <SID>vscodeGoToDefinition('revealDefinition')<CR>

" Git keymap settings
nnoremap ]c <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>
nnoremap [c <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>

" Navigation
nnoremap <leader>ff <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>

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

" window navigation
nnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
nnoremap <C-j> <Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
nnoremap <C-k> <Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
nnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
nnoremap <C-H> <Cmd>call VSCodeNotify('workbench.action.moveEditorToLeftGroup')<CR>
nnoremap <C-J> <Cmd>call VSCodeNotify('workbench.action.moveEditorToBelowGroup')<CR>
nnoremap <C-K> <Cmd>call VSCodeNotify('workbench.action.moveEditorToAboveGroup')<CR>
nnoremap <C-L> <Cmd>call VSCodeNotify('workbench.action.moveEditorToRightGroup')<CR>
nnoremap <C-w> <Cmd>call VSCodeNotify('workbench.action.focusNextGroup')<CR>
nnoremap <C-W> <Cmd>call VSCodeNotify('workbench.action.focusPreviousGroup')<CR>
nnoremap <C-p> <Cmd>call VSCodeNotify('workbench.action.focusPreviousGroup')<CR>

xnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
xnoremap <C-j> <Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
xnoremap <C-k> <Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
xnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
xnoremap <C-H> <Cmd>call VSCodeNotify('workbench.action.moveEditorToLeftGroup')<CR>
xnoremap <C-J> <Cmd>call VSCodeNotify('workbench.action.moveEditorToBelowGroup')<CR>
xnoremap <C-K> <Cmd>call VSCodeNotify('workbench.action.moveEditorToAboveGroup')<CR>
xnoremap <C-L> <Cmd>call VSCodeNotify('workbench.action.moveEditorToRightGroup')<CR>
xnoremap <C-w> <Cmd>call VSCodeNotify('workbench.action.focusNextGroup')<CR>
xnoremap <C-W> <Cmd>call VSCodeNotify('workbench.action.focusPreviousGroup')<CR>
xnoremap <C-p> <Cmd>call VSCodeNotify('workbench.action.focusPreviousGroup')<CR>
