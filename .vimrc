" -- Set up Vundle Plugin Manager -------------------------------------
" -- https://github.com/VundleVim/Vundle.vim
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" -- START: MY PLUGINS

" fold my classes and methods
Plugin 'tmhedberg/SimpylFold'

" autocomplete my code
" https://github.com/Valloric/YouCompleteMe#full-installation-guide
"Plugin 'Valloric/YouCompleteMe'

" syntax highlighting
Plugin 'scrooloose/syntastic'
" PEP8 check
Plugin 'nvie/vim-flake8'

" proper file tree
Plugin 'scrooloose/nerdtree'

" super search
Plugin 'kien/ctrlp.vim'

" bad whitespace
Plugin 'bitc/vim-bad-whitespace'

" -- END: MY PLUGINS

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" ----------------------------------------------------------------------


" Base16 like theme
colorscheme peachpuff


" use UTF-8
set encoding=utf-8


" define tabstops as spaces
set expandtab       " don't use actual tab character (ctrl-v)
set tabstop=4       " tabs are at proper location
set softtabstop=4   " indenting is four spaces
set shiftwidth=4    " indenting is four spaces


" for python dev use this indent
au BufNewFile,BufRead *.py,*.pyw set expandtab
au BufRead,BufNewFile *.py,*.pyw set textwidth=79
au BufRead,BufNewFile *.py,*.pyw set tabstop=4
au BufRead,BufNewFile *.py,*.pyw set softtabstop=4
au BufRead,BufNewFile *.py,*.pyw set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw set autoindent
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /\s\+$/
au         BufNewFile *.py,*.pyw set fileformat=unix
au BufRead,BufNewFile *.py,*.pyw let b:comment_leader = '#'


" indent
set autoindent      " turns on indent
set smartindent     " does the right thing


" no word wrap, yuck
set nowrap
set fo=cq
set textwidth=0


" python syntax
let python_highlight_all=1
" highlight everything
syntax on


" give me some numbers
"set number
"set numberwidth=3
"highlight LineNr ctermfg=008 ctermbg=NONE


" highlight overlength
"augroup vimrc_autocmds
"  autocmd BufEnter * highlight OverLength ctermbg=008
"  autocmd BufEnter * match OverLength /\%72v.*/
"augroup END


" display tabs and trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅


" search
"set incsearch   "find the next match as we type the search
"set hlsearch    "hilight searches by default


" fold classes and methods
set foldmethod=indent

" see previews of folded class doccs
let g:SimpylFold_docstring_preview=1


" Enable folding
set foldmethod=indent
set foldlevel=99


" fish shell fix
set shell=/bin/bash


" split to the right
"set splitright


" you complete me config
"let g:ycm_autoclose_preview_window_after_completion=1
"map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF


" ignore files in nerdtree
let NERDTreeIgnore=['\.pyc$', '\~$']

" close if nerdtree is the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" linenumber color
highlight LineNr ctermfg=DarkGrey


" statusline
set nocompatible
set noruler
set statusline=
"set statusline +=%1*\ %n\ %*            "buffer number
"set statusline +=%5*%{&ff}%*            "file format
"set statusline +=%3*%y%*                "file type
set statusline +=%4*\ %<%F%*            "full path
"set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
"set statusline +=%1*%4v\ %*             "virtual column number
"set statusline +=%2*0x%04B\ %*          "character under cursor
"set statusline +=[%{&fo}]               "show wrap options
set laststatus =2


" -- Hotkeys ----------------------------------------------------------

" toggleline numbers
"noremap <F3> :set invnumber<CR>
"inoremap <F3> <C-O>:set invnumber<CR>
noremap <F3> :call HybridNumberToggle()<CR>
inoremap <F3> <C-O>:call HybridNumberToggle()<CR>
function! HybridNumberToggle()
    if &nu == 0
        set nu
        set rnu
    else
        set nonu
        set nornu
    endif
endfunction


" toggle wrap
noremap <F4> :call AutoWrapToggle()<CR>
inoremap <F4> <C-O>:call AutoWrapToggle()<CR>
function! AutoWrapToggle()
    if &formatoptions =~ 't'
        set fo-=t
        set tw=0
        set statusline-=%1*]
    else
        set fo+=t
        set tw=72
        set statusline+=%1*]
    endif
endfunction


"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding with the spacebar
nnoremap <space> za

" open nerdtree
map <F5> :NERDTreeToggle<CR>
