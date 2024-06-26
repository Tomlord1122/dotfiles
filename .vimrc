" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start


set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  " Allow proper mouse use within tmux
  set ttymouse=xterm2
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  "colorscheme sublimemonokai
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif


" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
packadd matchit

" Line Numbers
set number

" Column @ char=80
 set colorcolumn=80
" set textwidth=80

" Buffer switching using Cmd-arrows in Mac and Alt-arrows in Linux
:nnoremap <D-Right> :bnext<CR>
:nnoremap <M-Right> :bnext<CR>
:nnoremap <D-Left> :bprevious<CR>
:nnoremap <M-Left> :bprevious<CR>
" and don't let MacVim remap them
if has("gui_macvim")
	 let macvim_skip_cmd_opt_movement = 1
endif

" Indentation (adapted from others..)

"""
" C
"""
autocmd BufNewFile,BufReadPost *.c set filetype=c
autocmd BufNewFile,BufReadPost *.h set filetype=c
autocmd FileType c setlocal
            \ tabstop=8
            \ noexpandtab
            \ shiftwidth=8
            \ softtabstop=8

"""
" C++
"""
autocmd BufNewFile,BufReadPost *.cpp set filetype=cpp
autocmd FileType cpp setlocal
            \ tabstop=4
            \ expandtab
            \ shiftwidth=4
            \ softtabstop=4


""""""""""
" Makefile
""""""""""
autocmd FileType make setlocal noexpandtab

""""""""""
" Markdown
""""""""""
autocmd Filetype markdown setlocal
            \ tabstop=4
            \ expandtab
            \ shiftwidth=4
            \ softtabstop=4
            \ textwidth=80

""""""""""
" Text
""""""""""
autocmd FileType text setlocal autoindent expandtab softtabstop=2 textwidth=80

""""""""""
" Python
"""""""""""
autocmd FileType python setlocal
            \ tabstop=4
            \ expandtab
            \ shiftwidth=4
            \ softtabstop=4

""""""""""
" Shell 
"""""""""""
autocmd FileType sh setlocal
            \ tabstop=4
            \ expandtab
            \ shiftwidth=4
            \ softtabstop=4

""""""""""
" json
"""""""""""
autocmd FileType json setlocal
            \ tabstop=4
            \ expandtab
            \ shiftwidth=4
            \ softtabstop=4


""""""""""
" js 
"""""""""""
autocmd FileType javascript setlocal
            \ tabstop=2
            \ expandtab
            \ shiftwidth=2
            \ softtabstop=2

""""""""""
" Haskell
"""""""""""
autocmd FileType haskell setlocal
            \ tabstop=2
            \ expandtab
            \ shiftwidth=2
            \ softtabstop=2

""""""""""
" OCaml
"""""""""""
autocmd FileType ocaml setlocal
            \ tabstop=4
            \ expandtab
            \ shiftwidth=4
            \ softtabstop=4

""""""""""
" go 
"""""""""""
autocmd FileType go setlocal
            \ tabstop=2
            \ expandtab
            \ shiftwidth=2
            \ softtabstop=2

" Yacc
"""""""""""
autocmd FileType yacc setlocal
            \ tabstop=4
            \ expandtab
            \ shiftwidth=4
            \ softtabstop=4

""""""""""
" sslang 
"""""""""""
autocmd FileType sslang setlocal
            \ tabstop=2
            \ expandtab
            \ shiftwidth=2
            \ softtabstop=2


"autocmd FileType help setlocal nospell



set ignorecase

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-python/python-syntax'
Plug 'tpope/vim-fugitive'
Plug 'edkolev/tmuxline.vim'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'
Plug 'tpope/vim-commentary'
Plug 'al3623/rippl.vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'fatih/vim-go'
Plug 'ocaml/vim-ocaml'
Plug 'luochen1990/rainbow'
Plug 'pangloss/vim-javascript'
Plug 'ssm-lang/sslang.vim'
Plug 'whonore/Coqtail'
call plug#end()

" vim-airline customizations
let g:airline_theme='bubblegum'
let g:airline#extensions#branch#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tmuxline#enabled = 1
let airline#extensions#tmuxline#snapshot_file = "~/.tmux-status.conf"

let g:tmuxline_preset = {
      \'a'    : '#P',
      \'b'    : '',
      \'c'    : '#W',
      \'x'    : ['%A','%m/%d/%y', '%I:%M %p'],
      \'y'    : '',
      \'z'    : '#H'}

" Sublime is a great theme!
colorscheme sublimemonokai

" Highlight the current line
set cursorline
highlight CursorLineNR cterm=bold ctermfg=81

" Enable all py highlighting
let g:python_highlight_all=1
let g:indentLine_color_term=8
let g:indentLine_char = '▏'

" Enable all Haskell highlighting features
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

" Go highlighting
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_diagnostic_errors = 1
let g:go_highlight_diagnostic_warnings = 1
let g:go_gopls_enabled = 0
let g:go_fmt_autosave=0
let g:rainbow_active = 1

set nocompatible
let mapleader = " "
