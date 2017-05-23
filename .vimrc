" Base16 like theme
colorscheme peachpuff


" define tabstops as spaces
set expandtab       " don't use actual tab character (ctrl-v)
set tabstop=4       " tabs are at proper location
set softtabstop=4   " indenting is four spaces
set shiftwidth=4    " indenting is four spaces


" indent
set autoindent      " turns on indent
set smartindent     " does the right thing


" no word wrap, yuck
set nowrap
set fo=cq
set textwidth=0


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


" statusline
set nocompatible
set noruler
set statusline=
"set statusline +=%1*\ %n\ %*            "buffer number
"set statusline +=%5*%{&ff}%*            "file format
"set statusline +=%3*%y%*                "file type
"set statusline +=%4*\ %<%F%*            "full path
"set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
"set statusline +=%1*%4v\ %*             "virtual column number
"set statusline +=%2*0x%04B\ %*          "character under cursor
"set statusline +=[%{&fo}]               "show wrap options
set laststatus =2


" Hotkeys

" toggleline numbers
noremap <F3> :set invnumber<CR>
inoremap <F3> <C-O>:set invnumber<CR>

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
