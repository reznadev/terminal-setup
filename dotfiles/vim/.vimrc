" Plugin Manager 
call plug#begin('~/.vim/plugged')

Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-eunuch'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-commentary'
Plug 'hashivim/vim-terraform'

call plug#end()

" Sneak vim
let g:sneak#label = 1

" Vim basic
set nocompatible
set backspace=indent,eol,start
set showcmd
set incsearch
set ignorecase
set smartcase
set tabstop=2
set shiftwidth=2
set softtabstop=0
set expandtab
set autoindent
set wildmenu
set hlsearch
syntax on
set relativenumber
set number
colorscheme habamax
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
nnoremap H 0
nnoremap L $
nnoremap <leader>l :nohlsearch<CR>
nnoremap <leader>w :wq<CR>
nnoremap <leader>q :q!<CR>
nnoremap <leader>t :terminal<CR>

" terraform specific 
let g:terraform_fmt_on_save = 1
filetype plugin indent on
