let skip_defaults_vim=1
set nocompatible

" activate line numbers
set number

" disable relative line numbers, remove no to sample it
set norelativenumber

" turn info in tray on even in default
set ruler

" tabs suck
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent
set smarttab
set autoindent

" easier to see characters when `set paste` is on
set listchars=tab:→\ ,eol:↲,nbsp:␣,space:·,trail:·,extends:⟩,precedes:⟨

" enoufh for line numbers + gutter within 80
set textwidth=73

" more risky, but cleaner
set nobackup
set noswapfile
set nowritebackup

" keep the terminal title updated
set laststatus=0
set icon

" center the cursor always on the screen
set scrolloff=999

" highlight search hits,  \+<cr> to clear
set hlsearch
set incsearch
set linebreak
map <silent> <leader><cr> :noh<cr>

" avoid most of the 'Hit Enter ...' messages
set shortmess=aoOtI

" prevents truncated yanks, deletes, etc.
set viminfo='20,<1000,s1000

" here because plugins and stuff need it
syntax enable

" allow sensing the filetype
filetype plugin on

" Install vim-plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" high contrast
set background=dark
colorscheme elflord

" only load plugins if Plug detected
if filereadable(expand("~/.vim/autoload/plug.vim"))
  call plug#begin('~/.vimplugins')
  Plug 'vim-pandoc/vim-pandoc'
  Plug 'https://gitlab.com/rwxrob/vim-pandoc-syntax-simple'
  Plug 'cespare/vim-toml'
  Plug 'pangloss/vim-javascript'
  Plug 'fatih/vim-go'
  Plug 'airblade/vim-gitgutter'
  Plug 'PProvost/vim-ps1'
  "Plug 'morhetz/gruvbox'
  call plug#end()
  let g:go_fmt_fail_silently = 0 " let me out even with errors
  let g:go_fmt_command = 'goimports' " autoupdate import
  let g:go_fmt_autosave = 1
  "set background=dark
  "colorscheme gruvbox
else
  autocmd vimleavepre *.go !gofmt -w % " backup if fatih fails
endif

" Just the defaults, these are changed per filetype by plugins.
" Most of the utility of all of this has been superceded by the use of
" modern simplified pandoc for capturing knowledge source instead of
" arbitrary raw text files.

set formatoptions-=t   " don't auto-wrap text using text width
set formatoptions+=c   " autowrap comments using textwidth with leader
set formatoptions-=r   " don't auto-insert comment leader on enter in insert
set formatoptions-=o   " don't auto-insert comment leader on o/O in normal
set formatoptions+=q   " allow formatting of comments with gq
set formatoptions-=w   " don't use trailing whitespace for paragraphs
set formatoptions-=a   " disable auto-formatting of paragraph changes
set formatoptions-=n   " don't recognized numbered lists
set formatoptions+=j   " delete comment prefix when joining
set formatoptions-=2   " don't use the indent of second paragraph line
set formatoptions-=v   " don't use broken 'vi-compatible auto-wrapping'
set formatoptions-=b   " don't use broken 'vi-compatible auto-wrapping'
set formatoptions+=l   " long lines not broken in insert mode
set formatoptions+=m   " multi-byte character line break support
set formatoptions+=M   " don't add space before or after multi-byte char
set formatoptions-=B   " don't add space between two multi-byte chars in join 
set formatoptions+=1   " don't break a line after a one-letter word
