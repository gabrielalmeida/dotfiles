"call pathogen#infect()
"call pathogen#helptags()
" Settings
set nocompatible
set sh=/bin/bash
set backupdir=~/.vim_backup//
set directory=~/.vim_swp//
set ruler
set number
set expandtab
set laststatus=2
set incsearch
set autoindent
set showcmd
set tabstop=2
set shiftwidth=2
set nowrap
set numberwidth=5
set ignorecase
set smartcase
set tags=./tags;
set guioptions-=T
set guioptions-=r
set foldenable
set foldmethod=manual
set mouse=a
set colorcolumn=80
set textwidth=80
set backspace=indent,eol,start

set completeopt=longest,menu
set wildmode=list:longest,list:full
set complete=.,t

" Set up Vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle "gmarik/vundle"

" My bundles
Bundle "kien/ctrlp.vim"
Bundle "Lokaltog/vim-distinguished"
Bundle "scrooloose/nerdtree"
Bundle "tomtom/tlib_vim"
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "bling/vim-airline"
Bundle "flazz/vim-colorschemes"
Bundle "tpope/vim-fugitive"
Bundle "tpope/vim-git"
Bundle "tpope/vim-surround"
Bundle "nono/vim-handlebars"
Bundle "pangloss/vim-javascript"
Bundle "groenewege/vim-less"
Bundle "garbas/vim-snipmate"
Bundle "honza/vim-snippets"

filetype plugin indent on
colorscheme distinguished
syntax on
highlight ColorColumn ctermbg=white

if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

"if has("autocmd")
  "filetype plugin indent on

  "autocmd BufNewFile,BufRead *.txt setfiletype text

  "autocmd FileType text,markdown,html,xhtml,eruby setlocal wrap linebreak nolist

  "au FocusLost * :set number
  "au InsertEnter * :set number

  "augroup vimrcEx
  "au!

  "autocmd BufReadPost *
    "\ if line("'\"") > 0 && line("'\"") <= line("$") |
    "\   exe "normal g`\"" |
    "\ endif

  " Automatically load .vimrc source when saved
  autocmd BufWritePost .vimrc source $MYVIMRC

  "augroup END

"else
  "set autoindent
"endif " has("autocmd")

" automatically open quickfix window on grep searches
autocmd QuickFixCmdPost *grep* cwindow

if has("gui_running")
  set guifont=Menlo\ Regular:h13
  " set guifont=Menlo\ Regular:h11
endif

" Functions
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

" Key Bindings
let mapleader = ","

inoremap kj <Esc>
nnoremap <Leader>n :call NumberToggle()<cr>

" Is this for autocomplete?
" imap <Tab> <C-N>

" Split windows
nnoremap <Leader>s :sp<cr><C-w><C-w>
nnoremap <Leader>v :vsp<cr><C-w><C-w>

" Easily switch between windows
nnoremap <silent> <c-k> :wincmd k<cr>
nnoremap <silent> <c-j> :wincmd j<cr>
nnoremap <silent> <c-h> :wincmd h<cr>
nnoremap <silent> <c-l> :wincmd l<cr>

" Exit insert mode and write file
inoremap <leader>w <Esc> :w<cr>
nnoremap <leader>w :w<cr>

" NERDTreeToggle
nnoremap <leader><Tab> :NERDTreeToggle<cr>
