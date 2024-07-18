let g:wiki_root = '~/vimwiki/text/'

" Define autocommand group for Git synchronization
augroup VimwikiGitSync
    autocmd!
    " Trigger GitSync on file save
    autocmd BufWritePost ~/vimwiki/text/* call GitSync()
    " Trigger GitPull on file open
    autocmd BufReadPost ~/vimwiki/text/* call GitPull()
augroup END

" Function to add, commit, and push changes to Git
function! GitSync()
    let l:current_dir = getcwd()
    exe 'cd ~/vimwiki/'
    silent! !git add .
    if v:shell_error
        echo "Git add failed"
        exe 'cd' fnameescape(l:current_dir)
        return
    endif
    silent! !git commit -m 'Auto-commit from Vim'
    if v:shell_error
        echo "Git commit failed"
        exe 'cd' fnameescape(l:current_dir)
        return
    endif
    !git push origin main
    exe 'cd' fnameescape(l:current_dir)
endfunction

" Function to pull the latest changes from Git
function! GitPull()
    let l:current_dir = getcwd()
    exe 'cd ~/vimwiki/'
    !git pull origin main
    exe 'cd' fnameescape(l:current_dir)
endfunction
