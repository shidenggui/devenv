"*********************************************************************
" General
"*********************************************************************
"
" Make Vim more useful
set nocompatible

" Optimize for fast terminal connections
set ttyfast

" Set to auto read when a file is changed from the outside
set autoread

" Enhance command-line completion
set wildmenu
set wildmode=longest:full,full

" Ignore case of searches
set ignorecase

" When searching try to be smart about cases
set smartcase

" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
  set undodir=~/.vim/undo
  set undofile
endif
set nobackup
set nowritebackup
set noswapfile

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Change mapleader
let mapleader=","

"*********************************************************************
" Appearance
"*********************************************************************

set background=dark
syntax on
syntax enable

let g:molokai_original = 1
" let g:rehash256 = 1
colorscheme molokai

" Don’t show the intro message when starting Vim
set shortmess=a
set cmdheight=2

" Show the filename in the window titlebar
set title

" Enable line numbers
set number

" show the cursor position
set ruler

" Disable error bells
set noerrorbells

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,nbsp:_
set list

" Highlight searches
set hlsearch

" Highlight dynamically as pattern is typed
set incsearch

" Disable the jedi preview window feature
autocmd FileType python setlocal completeopt-=preview

autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

filetype indent on           " auto indent according to file types
set t_Co=256

filetype off                  " required

" for space indent
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" " when indenting with '>', use 4 spaces width
set shiftwidth=4
" " On pressing tab, insert 4 spaces
set expandtab

"set autoindent
" set smartindent
set cindent
set softtabstop=4

set showmatch
set wrap

set autochdir

"*********************************************************************
" Keymap
"*********************************************************************

noremap <silent> <leader>s :update<CR> 

" Move cursor by display lines when wrapping
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$

"*********************************************************************
" Plugins
"*********************************************************************

call plug#begin('~/.vim/plugged')
filetype plugin on           " load correspondent plugin accordint to file types

Plug 'jiangmiao/auto-pairs'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'tomasr/molokai'

Plug 'fatih/vim-go'
let g:go_fmt_command = "goimports"

Plug 'majutsushi/tagbar' 
nmap <C-t> :TagbarToggle<CR>

Plug 'Lokaltog/vim-powerline'
let g:Powerline_symbols = 'unicode'

Plug 'hdima/python-syntax'
let python_highlight_all = 1

Plug 'scrooloose/nerdtree'
map <leader>, :NERDTreeToggle<CR>

Plug 'tacahiroy/ctrlp-funky'
nnoremap <C-f> :CtrlPFunky<CR>

Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

call plug#end()

