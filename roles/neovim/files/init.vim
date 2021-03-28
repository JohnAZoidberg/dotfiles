" Leader is comma
let mapleader = ","

noremap  <leader><space> :nohlsearch<cr><leader><space> " turn off search highlight
nnoremap <silent><leader>w :%s/\s\+$//<cr>  " delete all trailing whitespace
vnoremap <c-a> <esc>ggVG                    " select entire file
cmap w!! w !sudo tee > /dev/null %          " save as sudo
nmap <silent> <leader><space> :set invhlsearch<CR>

set nowrap

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set modeline

" Show a preview of the search and replace commmand
if has('nvim')
  set inccommand=nosplit
end

" Use ripgrep with fzz as :grep
if executable('rg')
  set grepprg=rg\ --vimgrep
endif

" In visual mode don't include the newline-character when jumping to
" end-of-line with $
vnoremap $ $h

"set splitbelow
"set splitright

"Search
set ignorecase
set smartcase
"https://neovim.io/doc/user/vim_diff.html#nvim-defaults
"https://www.reddit.com/r/vim/comments/bgumn8/til_about_diffoptiwhite/
set diffopt +=iwhiteall
set diffopt+=internal,algorithm:patience
set diffopt+=hiddenoff


set termguicolors
colorscheme NeoSolarized
set background=light

" Enable the mouse (for resizing splits)
set mouse=a

call plug#begin(stdpath('data') . '/plugged')

Plug 'dhruvasagar/vim-table-mode'
let g:table_mode_corner='|'

"Plug 'vmchale/dhall-vim'
Plug 'LnL7/vim-nix'

" surround with s
Plug 'tpope/vim-surround'

" Git plugin
Plug 'tpope/vim-fugitive'

" Start a * or # search from a visual selection
Plug 'bronson/vim-visual-star-search'

" Support for many languages
Plug 'sheerun/vim-polyglot'

call plug#end()
