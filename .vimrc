" Load plugins from the bundle directory
call pathogen#infect() 
call pathogen#helptags() 

" Use Vim settings, rather than Vi
set nocompatible

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" Remember 1000 commands and search history
set history=1000

" Make tab completion for files/buffers act like bash
set wildmenu

" Make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase

" Keep more context when scrolling off the end of a buffer
"set scrolloff=3

" Show the cursor position all the time
set ruler

" Display incomplete commands
set showcmd

" Size of tabs
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set laststatus=2

" Use 2-space tabs for sls, html, json, and yaml files
au BufRead,BufNewFile *.sls set filetype=yaml
au FileType yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2
au FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
au FileType json setlocal shiftwidth=2 tabstop=2 softtabstop=2
au BufNewFile *.py :silent! 0r ~/.python_module.template

set showmatch
set incsearch
set hls

set cursorline
"set cmdheight=2

"Don't reopen buffers
set switchbuf=useopen

set showtabline=2

" Make command-t ignore unimportant files
set wildignore=*.swp,*.bak,*.pyc,*.class,*.jar,*.gif,*.png,*.jpg

syntax enable
syntax on
set t_Co=256
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"
set background=light
colorscheme solarized

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz

" Set fileformat to Unix
set ff=unix

" Set encoding to UTF
set enc=utf-8

" Line numbers on
set nu

" Enable use of mouse
set mouse=a

" Use 'g' flag by default with :s/foo/bar
set gdefault

" allow cursor to wrap to next/prev line
set whichwrap=h,l

" smart indent, does c style indenting
"set nosi

" Set autocomplete to on
filetype plugin on
filetype plugin indent on

function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" Execute file being edited with <leader> + e:
map <leader>e :call SmartRun()<cr>

function! SmartRun()
    :w
    :silent !clear
    if match(expand("%"), '.py$') != -1
        exec ":!python " . @%
    elseif match(expand("%"), '.sh$') != -1
        exec ":!bash " . @%
    elseif match(expand("%"), '.rb$') != -1
        exec ":!ruby " . @%
    end
endfunction

" remap leader-leader to go back one file
nnoremap <leader><leader> <c-^>

" Map leader-r to do a global replace of a word
map <leader>r :%s/<C-R>=expand("<cword>")<CR>/<C-R>=expand("<cword>")<CR>

" Map leader-g to grep the hovered word in the current workspace
map <leader>g :grep -IR <cword> * <CR><CR> :copen <CR> <C-w><C-k>

" Fast tab navigation
map <leader>1 1gt
map <leader>2 2gt
map <leader>3 3gt
map <leader>4 4gt
map <leader>5 5gt
map <leader>6 6gt
map <leader>7 7gt
map <leader>8 8gt
map <leader>9 9gt

" Go to next/prev result with <Ctrl> + n/p
nmap <silent> <C-N> :cn<CR>zv
nmap <silent> <C-P> :cp<CR>zv

" Scroll while keeping the cursor in place with <Ctrl> + j/k
map <C-j> j<C-e>
map <C-k> k<C-y>

" Remap q: to just go to commandline.  To open the commandline window, 
" do <C-f> from the commandline
nnoremap q: :

" Navigate tabs with <S-Tab>
map <S-Tab> gt

" Smart folding
au BufEnter * if !exists('b:all_folded') | let b:all_folded = 1 | endif
function! ToggleFold()
    if( b:all_folded == 0 )
        exec "normal! zM"
        let b:all_folded = 1
    else
        exec "normal! zR"
        let b:all_folded = 0
    endif
endfunction
map f za
map F :call ToggleFold()<CR>

" Auto-indent on line wrap
set showbreak=--->

" Close the scratch preview automatically
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Close quickfix if it's the only visible buffer
aug QFClose
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END

" Tab completion
function! CleverTab()
    if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
        return "\<Tab>"
    else
        if match(expand("%"), '.py$') != -1
            return "\<C-x>\<C-o>"
        else
            return "\<C-P>"
        endif
    endif
endfunction
imap <Tab> <C-R>=CleverTab()<CR>

" Do syntax checking on file open
let g:syntastic_check_on_open=1
let g:syntastic_mode_map = { 'mode': 'active',
                               \ 'passive_filetypes': ['python'] }
