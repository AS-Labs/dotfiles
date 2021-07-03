set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set completeopt=menuone,noinsert,noselect
set signcolumn=yes
set colorcolumn=80
set cmdheight=2
set updatetime=50
set shortmess+=c
set nocompatible

call plug#begin('~/.vim/plugged')



Plug 'sheerun/vim-polyglot'
Plug 'gruvbox-community/gruvbox'
Plug 'ycm-core/YouCompleteMe'




" Initialize plugin system
call plug#end()


highlight Normal guibg=NONE
colorscheme gruvbox

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup AS_LABS
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END
