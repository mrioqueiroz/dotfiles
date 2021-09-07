set background=dark

let mapleader=" "

set autoread
au CursorHold,CursorHoldI * checktime
au FocusGained,BufEnter * checktime

set nowrap
set textwidth=0
set wrapmargin=0
set whichwrap+=<,>,h,l,[,]
set history=1000
set undolevels=500
set colorcolumn=80

nnoremap <leader>z :tabedit %<CR>

set number
set relativenumber
augroup toggle_relative_number
autocmd InsertEnter * :setlocal norelativenumber
autocmd InsertLeave * :setlocal relativenumber

vnoremap <C-c> "+y

set cursorline
set cursorcolumn
set ignorecase
set incsearch
set noerrorbells
set novisualbell
set hidden
set foldcolumn=2

autocmd BufNewFile *.sh 0r ~/.vim/templates/sh
autocmd BufNewFile shell.nix 0r ~/.vim/templates/shell.nix

set shiftwidth=2
set softtabstop=2
set expandtab

nmap <leader>/ :nohlsearch<CR>

set undodir=~/.vimdid
set undofile

colorscheme gruvbox
let g:rustfmt_autosave = 1
let g:ale_linters = {'rust': ['analyzer']}

map <leader>o :NERDTreeToggle<cr>
map <leader>; :Files<cr>
map <leader>[ :GFiles<cr>
map <leader>] :Buffers<cr>
map <leader>g :GrepperRg<space>--ignore-case<space>

map <leader>j :w<cr>
map <leader>q :q<cr>

vnoremap <leader>e c<c-r>=system('base64', @")<cr><bs><space><esc>gv :s/\s\+$//e<cr>:nohlsearch<cr>
vnoremap <leader>d c<c-r>=system('base64 --decode', @")<cr><esc>

vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '>-2<CR>gv=gv

nnoremap <leader><space> <c-^>

tnoremap jj <C-\><C-n>
inoremap jj <esc>:w<cr>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
noremap <PageUp> <Nop>
noremap <PageDown> <Nop>

nnoremap <leader>c* *Ncgn

nnoremap <leader>a gg<s-v>G


if executable('rg')
    set grepprg=rg\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

augroup remember_folds
  autocmd!
  autocmd BufWinLeave * silent! mkview
  autocmd BufWinEnter * silent! loadview
augroup END
