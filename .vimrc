execute pathogen#infect()
syntax on " auto-detect language and colorize keywords appropriately
colorscheme monokai

set wrap " wrap lines
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set expandtab " all this does is convert tabs to spaces (useful for yaml, Python, etc.)

set number " shows line numbers
set showcmd " shows the last command entered in the very bottom right of Vim

filetype indent on " turns on filetype detection and allows loading of language specific indentation
set wildmenu " gives a graphical menu of all the matches you can cycle through
set showmatch " highlights matching brackets, braces, parentheses, etc.

set foldenable " enables folding, which is pretty sweet in vim
set foldlevelstart=10 " auto-folding starts when we are 10 nested blocks in (bad and/or very complex code)
set foldnestmax=10 " maximum number of nested blocks that can be folded.
set foldmethod=marker " you can specify a method to indicate folded folds in vim
set backspace=indent,eol,start
set term=xterm-256color

" enable cut and paste to and from the system clipboard
set clipboard=unnamed,unnamedplus

" build a usable statusbar
set laststatus=2

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

let g:airline_powerline_fonts=1
set t_Co=256
set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

" ctrlp stuff
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_workign_path_mode = 'ra'
set wildignore+=*/tmp*,/*.so,*.swp,*.zip


nnoremap B ^
nnoremap E $

augroup python_files "{{{
        " PEP8 compliance (set 1 tab = 4 chars explicitly, even if set
        " earlier, as it is important)
        autocmd filetype python setlocal textwidth=80
        autocmd filetype python match ErrorMsg '\%>80v.+'
        " disable autowrapping
        autocmd filetype python setlocal formatoptions-=t
augroup end " }}}

" yaml made easy
au! BufNewFile, BufReadPost *.{yaml, yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal textwidth=80 ts=2 sts=2 sw=2 expandtab

call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'xavierchow/vim-swagger-preview'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()
