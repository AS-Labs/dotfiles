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
set colorcolumn=100
set cmdheight=2
set updatetime=50
set shortmess+=c
set nocompatible

call plug#begin('~/.vim/plugged')



Plug 'sheerun/vim-polyglot'
Plug 'gruvbox-community/gruvbox'
Plug 'ycm-core/YouCompleteMe'
Plug 'vim-scripts/AutoComplPop'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'yuttie/comfortable-motion.vim'








set background=dark
set complete+=kspell
set completeopt=menuone,longest
" Initialize plugin system
call plug#end()


highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE
colorscheme gruvbox
let g:gruvbox_transparent_bg = 1

autocmd BufWritePre *.py execute ':Black'
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!clear; python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!clear; python3' shellescape(@%, 1)<CR>
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

" VIM Smooth scrolling
let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"
noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>
nnoremap <silent> <C-d> :call comfortable_motion#flick(100)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(-100)<CR>

augroup AS_LABS
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END
