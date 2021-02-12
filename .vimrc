set background=dark
set number
set relativenumber
set cursorline

hi CursorLine term=bold cterm=bold ctermfg=white

set showcmd
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set nowrap
set autoindent
set smartindent
set smarttab
set smartcase
set backspace=indent,eol,start
set showmatch
set mat=2
set autoread
set wildmenu
set ignorecase
set hlsearch
set incsearch
set magic
set noerrorbells
set novisualbell
set t_db=
set tm=500
set scrolloff=4
set encoding=utf8
set lazyredraw
set history=1000
set undolevels=500
set mouse=a

autocmd Filetype gitcommit setlocal spell textwidth=72
syntax on
filetype indent on

let python_highlight_all=1
let python_space_error_highlight=1
