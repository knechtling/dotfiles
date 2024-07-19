let g:wiki_tag_scan_num_lines = 2
let g:wiki_root = '~/vimwiki/text/'
nnoremap <silent> <leader>ww :WikiIndex<CR>
nnoremap <silent> <leader>wj :WikiJournal<CR>
nnoremap <silent> <leader>wp :WikiPages<CR>
nnoremap <silent> <leader>wt :WikiTags<CR>


"" Syncronize files in the ~/vimwiki directory with git
"" You can add another directory to be synced by creating new autocmd's
" Define global variable to track if sync has been done
let g:vimwiki_synced = 0

" Define autocommand group for Git synchronization
augroup VimwikiGitSync
    autocmd!
    " Trigger GitSync on file save
    autocmd BufWritePost ~/vimwiki/text/* call GitSync()
    " Trigger GitPull only if not already synced in this session
    autocmd BufReadPost ~/vimwiki/text/* call CheckAndSync()
augroup END

" Function to add, commit, and push changes to Git
function! GitSync()
    let l:current_dir = getcwd()
    cd %:h
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
    silent! !git push
    if v:shell_error
        echo "Git push failed"
    endif
    exe 'cd' fnameescape(l:current_dir)
endfunction

" Function to check if Git sync is needed and perform GitPull
function! CheckAndSync()
    echom "CheckAndSync called"
    echom "g:vimwiki_synced value: " . g:vimwiki_synced
    if g:vimwiki_synced == 0
        echom "Sync not done yet. Running GitPull."
        call GitPull()
        let g:vimwiki_synced = 1
        echom "g:vimwiki_synced set to 1"
    else
        echom "Sync already done. Skipping GitPull."
    endif
endfunction

" Function to pull the latest changes from Git
function! GitPull()
    echom "GitPull called"
    let l:current_dir = getcwd()
    cd %:h
    call jobstart(['git', 'pull'], {'cwd': expand('%:p:h'), 'on_exit': 's:GitPullCallback'})
    exe 'cd' fnameescape(l:current_dir)
endfunction

" Callback function to reload buffers after Git pull
function! s:GitPullCallback(job_id, data, event)
    if a:event == 'exit'
        if a:data[0] == 0
            " Reload the buffer if the git pull was successful
            call s:ReloadVimwikiBuffers()
            echom "Git pull and buffer reload successful"
        else
            echom "Git pull failed"
        endif
    endif
endfunction

" Function to reload Vimwiki buffers
function! s:ReloadVimwikiBuffers()
    echom "Reloading Vimwiki buffers"
    for buf in getbufinfo({'bufloaded': 1})
        if buf.name =~# '^' . expand('~/vimwiki/text/')
            silent! execute 'edit ' . buf.name
        endif
    endfor
endfunction

" Minimal .vimrc for testing Vimwiki Git synchronization

" Define global variable to track if sync has been done
let g:vimwiki_synced = 0

" Define autocommand group for Git synchronization
augroup VimwikiGitSync
    autocmd!
    " Trigger GitSync on file save
    autocmd BufWritePost ~/vimwiki/text/* call GitSync()
    " Trigger GitPull only if not already synced in this session
    autocmd BufReadPost ~/vimwiki/text/* call CheckAndSync()
augroup END

" Function to add, commit, and push changes to Git
function! GitSync()
    let l:current_dir = getcwd()
    exe 'cd ' . expand('%:p:h')
    silent! call system('git add .')
    if v:shell_error
        call system('notify-send "Vim Sync" "Git add failed"')
        exe 'cd' fnameescape(l:current_dir)
        return
    endif
    silent! call system('git commit -m "Auto-commit from Vim Sync"')
    if v:shell_error
        call system('notify-send "Vim Sync" "Git commit failed"')
        exe 'cd' fnameescape(l:current_dir)
        return
    endif
    silent! call system('git push')
    if v:shell_error
        call system('notify-send "Vim Sync" "Git push failed"')
    endif
    exe 'cd' fnameescape(l:current_dir)
endfunction

" Function to check if Git sync is needed and perform GitPull
function! CheckAndSync()
    if g:vimwiki_synced == 0
        call system('notify-send "Vim Sync" "Sync not done yet. Running git pull."')
        call GitPull()
        let g:vimwiki_synced = 1
        call system('notify-send "Vim Sync" "g:vimwiki_synced set to 1"')
    else
        call system('notify-send "Vim Sync" "Sync already done. Skipping git pull."')
    endif
endfunction

" Function to pull the latest changes from Git
function! GitPull()
    let l:current_dir = getcwd()
    call jobstart(['git', 'pull'], {'cwd': expand('%:p:h'), 'on_exit': 's:GitPullCallback'})
    exe 'cd' fnameescape(l:current_dir)
endfunction

" Callback function to reload buffers after Git pull
function! s:GitPullCallback(job_id, data, event)
    if a:event == 'exit'
        if a:data[0] == 0
            " Reload the buffer if the git pull was successful
            call s:ReloadVimwikiBuffers()
            call system('notify-send "Vim Sync" "Git pull and buffer reload successful"')
        else
            call system('notify-send "Vim Sync" "Git pull failed"')
        endif
    endif
endfunction

" Function to reload Vimwiki buffers
function! s:ReloadVimwikiBuffers()
    for buf in getbufinfo({'bufloaded': 1})
        if buf.name =~# '^' . expand('~/vimwiki/text/')
            silent! execute 'edit ' . buf.name
        endif
    endfor
endfunction

