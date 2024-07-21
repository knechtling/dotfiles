let mapleader=","

set title
set bg=light
set go=a
set mouse=a 
set nohlsearch 
set clipboard+=unnamedplus
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set ttimeout
set ttimeoutlen=50

source ~/.config/nvim/plugins.vim
source ~/.config/nvim/custom_functions.vim
source ~/.config/nvim/vimtex.vim

" Some basics:
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	filetype indent on
	syntax on
	set encoding=utf-8
	set number relativenumber
	colorscheme catppuccin-macchiato "catppuccin-latte catppuccin-mocha catppuccin catppuccin-frappe, catppuccin-macchiato,

" Ensure keybindings are set after all plugins are loaded
nnoremap <M-c> <Nop>
inoremap <M-c> <Nop>
" vimwiki
"nnoremap <C-p> :VimwikiConvert2Pdf
"nnoremap <F5> :VimwikiConvert2PdfOpen

" ultisnips
let g:UltiSnipsExpandTrigger = "<C-k>"
let g:UltiSnipsJumpForwardTrigger = "<C-k>"
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/plugged/vim-easycomplete/snippets/ultisnips']
let g:UltiSnipsEditSplit="horizontal"
let g:easycomplete_nerd_font = 1
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
	vnoremap . :normal .,
" Goyo plugin makes text more readable when writing prose:
	map <leader>f :Goyo \| set bg=light \| set linebreak
" Spell-check set to o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" Nerd tree
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    if has('nvim')
        let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
    else
        let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
    endif


" vimling:
	nm <leader>d :call ToggleDeadKeys()
	imap <leader>d :call ToggleDeadKeys()a
	nm <leader>i :call ToggleIPA()
	imap <leader>i :call ToggleIPA()a
	nm <leader>q :call ToggleProse()

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Replace ex mode with gq
	map Q gq

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck -x %

" Open my bibliography file in split
	map <leader>b :vsp$BIB
	map <leader>r :vsp$REFER

" Replace all is aliased to S.
	nnoremap S :%s//g

" Compile document, be it groff/LaTeX/markdown/etc.
	map <leader>c :w! \| !compiler "%:p"<CR>

" Open corresponding .pdf/.html or preview
	map <leader>p :!opout "%:p"<CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	map <leader>ww :VimwikiIndex<CR>
	let g:vimwiki_list = [{'path': '~/vimwiki/text', 'path_html': '~/vimwiki/html', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
 	" autocmd BufWritePre * let currPos = getpos(".")
	" autocmd BufWritePre * %s/\s\+$//e
	" autocmd BufWritePre * %s/\n\+\%$//e
  	" autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !shortcuts

" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %

" Recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }
	autocmd BufWritePost ~/repos/dwmblocks/blocks.h !cd ~/repos/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

nnoremap <leader>h :call ToggleHiddenAll()<CR>
" Load command shortcuts generated from bm-dirs and bm-files via shortcuts script.
" Here leader is ";".
" So ":vs ;cfz" will expand into ":vs /home/<user>/.config/zsh/.zshrc"
" if typed fast without the timeout.
silent! source ~/.config/nvim/shortuts.vim
silent! source ~/.config/nvim/md-preview.vim
silent! source ~/.config/nvim/wiki.vim
silent! source ~/.config/nvim/easycomplete.vim
silent! source ~/.config/nvim/which-key.vim
silent! source ~/.config/nvim/ultisnips.vim
silent! source ~/.config/nvim/ctrlf.vim
silent! source ~/.config/nvim/telescope.vim
silent! source ~/.config/nvim/treesitter.vim
