" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number


" Highlight search results
set hlsearch

" Enable line wrapping
set wrap

" Set the number of spaces that a tab represents
set tabstop=2     " Use 4 spaces for a tab

