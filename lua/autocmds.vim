
" save/remember view - which includes folds and cursor position.
" source: https://stackoverflow.com/a/54739345
augroup remember_view
  autocmd!
  au BufWinLeave ?* mkview 1
  au BufWinEnter ?* silent! loadview 1
augroup END

" don't continue comment after new line
" source: https://superuser.com/a/271024
autocmd FileType * set formatoptions-=cro

" neovim terminal autocmd - for BufTermOpen instead of TermOpen
" source: https://stackoverflow.com/a/63909865
augroup neovim_terminal
    autocmd!
    " Enter Terminal-mode (insert) automatically
    autocmd TermEnter * startinsert
    " Disables number lines on terminal buffers
    autocmd TermEnter * :set nonumber norelativenumber
    " allows you to use Ctrl-c on terminal window
    autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
augroup END
