execute pathogen#infect()
syntax on " auto-detect language and colorize keywords appropriately
colorscheme monokai

set wrap " wrap lines
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set expandtab " all this does is convert tabs to spaces (useful for yaml, Python, etc.)
set backspace=indent,eol,start

set number " shows line numbers
set showcmd " shows the last command entered in the very bottom right of Vim

filetype indent on " turns on filetype detection and allows loading of language specific indentation
set wildmenu " gives a graphical menu of all the matches you can cycle through
set showmatch " highlights matching brackets, braces, parentheses, etc.

set foldenable " enables folding, which is pretty sweet in vim
set foldlevelstart=10 " auto-folding starts when we are 10 nested blocks in (bad and/or very complex code)
set foldnestmax=10 " maximum number of nested blocks that can be folded.
set foldmethod=marker " you can specify a method to indicate folded folds in vim

nnoremap B ^
nnoremap E $
nnoremap w <C-w>

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
