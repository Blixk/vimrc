call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch':'release'}
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'xavierchow/vim-swagger-preview'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ekalinin/Dockerfile.vim'
Plug 'derekwyatt/vim-scala'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'sheerun/vim-polyglot'
Plug 'pearofducks/ansible-vim'
Plug 'vim-scripts/taglist.vim'
Plug 'tpope/vim-dadbod'
Plug 'arcticicestudio/nord-vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
call plug#end()

execute pathogen#infect()
let python_highlight_all=1
syntax on " auto-detect language and colorize keywords appropriately
"colorscheme monokai
colorscheme nord

set wrap " wrap lines
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set expandtab " all this does is convert tabs to spaces (useful for yaml, Python, etc.)
set shiftwidth=4
set hlsearch
noremap y "*y

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

" build a usable statusbar
set laststatus=2

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

"Use <c-space to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

"git gitgutter
highlight GitGutterAdd guifg=#009900 ctermfg=Green
highlight GitGutterChange guifg=#bbbb00 ctermfg=Yellow
highlight GitGutterDelete guifg=#ff2222 ctermfg=Red
nmap ) <Plug>(GitGutterNextHunk)
nmap ( <Plug>(GitGutterPrevHunk)
let g:gitgutter_enabled=1
let g:gitgutter_map_keys=0


" airline stuff
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

" syntastic stuff
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0


" ale stuff
let g:ale_lint_on_enter=0
let g:ale_lint_on_save=1
let g:ale_sign_error="**"
let g:ale_sign_warning="*"

nnoremap B ^
nnoremap E $

augroup python_files "{{{
        " PEP8 compliance (set 1 tab = 4 chars explicitly, even if set
        " earlier, as it is important)
        autocmd FileType python setlocal textwidth=80
        autocmd FileType python match ErrorMsg '\%>80v.+'
        " disable autowrapping
        autocmd FileType python setlocal formatoptions-=t
augroup end " }}}

" yaml made easy
au! BufNewFile, BufReadPost *.{yaml, yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal textwidth=80 ts=2 sts=2 sw=2 expandtab

" Jenkinsfiles made less painful
au! BufNewFile, BufRead Jenkinsfile setf groovy

" Java files can use javacomplete
augroup java_files
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
augroup end

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
" Recently vim can merge signcolumn and number column into one
    set signcolumn=number
else
    set signcolumn=yes
endif
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                     \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction
" Highlight the symbol and its references when
" holding the cursor.
" autocmd CursorHold * silent call
" CocActionAsync('highlight')
"
"" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
 xmap <leader>f  <Plug>(coc-format-selected)
 nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json set formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl <Plug>(coc-codelens-action)

"" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s>  <Plug>(coc-range-select)
xmap <silent> <C-s>  <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that provide custom statusline:
"lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p :<C-u>CocListResume<CR>
