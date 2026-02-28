" function! ToggleVimwikiTableMappings()
"     if exists("g:vimwiki_key_mappings")
"         if get(g:vimwiki_key_mappings, 'table_mappings', 0) == 1
"             let g:vimwiki_key_mappings = { 'table_mappings': 0, }
"             echom "Vimwiki table mappings disabled"
"         else
"             let g:vimwiki_key_mappings = { 'table_mappings': 1, }
"             echom "Vimwiki table mappings enabled"
"         endif
"     else
"         let g:vimwiki_key_mappings = {'table_mappings': 0}
"         echom "Vimwiki table mappings initialized to disabled"
"     endif

" 	mksession! ~/vim_session.vim
" 	execute '!restart_vim.sh'
" endfunction
" nnoremap <leader>vt :call ToggleVimwikiTableMappings()

" Function for toggling the bottom statusbar:
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction

function! ConvertToPDF()
  " Get the full path of the current file
  let l:fullpath = expand('%:p')
  " Replace 'text' with 'pdf' in the path
  let l:pdfpath = substitute(l:fullpath, '/text/', '/pdf/', '')
  " Change the file extension from .wiki to .pdf
  let l:pdfpath = substitute(l:pdfpath, '\.wiki$', '.pdf', '')

  " Get the directory path without the file name
  let l:dirpath = fnamemodify(l:pdfpath, ':h')

  " Create the directory if it doesn't exist
  if !isdirectory(l:dirpath)
    call mkdir(l:dirpath, 'p')
  endif
  " Construct the pandoc command and execute it
  let l:pandoc_cmd = 'pandoc -V geometry:margin=0.2in -f vimwiki -t pdf -o ' . l:pdfpath . ' ' . l:fullpath
  execute '!'.l:pandoc_cmd
  return l:pdfpath
endfunction

function! ConvertToPDFOpen()
	let l:pdfpath = ConvertToPDF()
	execute '!zathura ' . l:pdfpath . ' &'
endfunction

command! VimwikiConvert2Pdf call ConvertToPDF()
command! VimwikiConvert2PdfOpen call ConvertToPDFOpen()
