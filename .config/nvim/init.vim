" Required by vundle
set nocompatible
filetype off

call plug#begin()

" Nice syntax highlighting stuff
Plug 'rust-lang/rust.vim'
Plug 'w0rp/ale'

" Fancy powerbar
Plug 'vim-airline/vim-airline'
" File tree 
Plug 'scrooloose/nerdtree'

" Search functionality for files
Plug 'ctrlpvim/ctrlp.vim'

" Search in files with fzf (fuzzy file searcher)
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" To be able to link colleagues to github & gitlab
Plug 'knsh14/vim-github-link'

" GruvBox colorscheme
Plug 'morhetz/gruvbox'

" In order to interact and get erlang syntax highlighting
Plug 'vim-erlang/vim-erlang-runtime'

" In order to get terraform syntax highlighting
Plug 'hashivim/vim-terraform'

call plug#end()

" Enable ALE as a linter in the powerbar
let g:airline#extensions#ale#enabled = 1

" Remap ALE formatting with Ctrl+C
nnoremap <C-c> :ALEFix<CR>

" Remap the nerdtree functionality
" Ctrl+J = find current file
nnoremap <C-j> :NERDTreeFind<CR>

" Ctrl+P to open CTRLP for fuzzy file search
nnoremap <C-p> :CtrlP<CR>

" Ctrl+f to open FZF [ripgrep backed] to search
" file contents
nnoremap <C-f> :Rg<CR>

" Ctrl+S+G to copy the git remote link
nnoremap <C-S-g> :GetCurrentBranchLink<CR>
vnoremap <C-S-g> :GetCurrentBranchLink<CR>

" Allows searching across multiple git repositories
let g:ctrlp_working_path_mode = ''

" Use rip-grep (faster than grep) for ctrl+p
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
else
  let g:ctrlp_clear_cache_on_exit = 0
endif

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors

" Automatic indentation
set autoindent
set shiftwidth=2
set tabstop=2
set expandtab
set backspace=indent,eol,start
set hlsearch
" Enable line numbers
set number

" Disable swap file clutter
set swapfile
set dir=~/tmp

" Disable flash for errors
set noerrorbells
" Expand the search history to 1k
set history=1000

" Enable syntax highlighting by default
syntax on
filetype plugin indent on
colorscheme gruvbox

" Force yaml.template files to match against yaml files
au BufRead,BufNewFile *.yaml.template set filetype=yaml

" Remap keys to make it easier to do tab navigation
nnoremap <S-h> :tabprevious<CR>
nnoremap <S-l> :tabnext<CR>
nnoremap <S-t> :tabnew<CR>
nnoremap <S-w> :tabclose<CR>

set laststatus=2
set encoding=utf-8

" Enable the mouse
set mouse=a
