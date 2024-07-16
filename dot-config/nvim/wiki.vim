let g:wiki_root = '~/vimwiki/text/'

augroup VimwikiGitSync
    autocmd!
    autocmd BufWritePost ~/vimwiki/text/* call GitSync()
augroup END

function! GitSync()
    let l:current_dir = getcwd()
    exe 'cd ~/vimwiki/'
    silent! !git add .
    silent! !git commit -m "Auto commit of %:t." "%"
    silent! !git push
    exe 'cd' fnameescape(l:current_dir)
endfunction


