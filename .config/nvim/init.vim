" Martin Palmowski init.vim for neovim, based on stuff from Wes Doyle and Juan
" Pedro Fisanotti. I'm truly amazed how much customization is possible and how
" much these pleople actually put in to it.
"
" Load vim-plug
let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    silent !mkdir -p ~/.config/nvim/autoload
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        let vim_plug_just_installed = 1
endif

" manually load vim-plug the first time
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif

set nocompatible
syntax on
filetype off

call plug#begin('~/.config/nvim/plugged')

" Plugins from github repos:
"=== Eye Candy ===
Plug 'NLKNguyen/papercolor-theme'
"Plug 'dracula/vim'
"Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Paint css colors with the real color
Plug 'lilydjwg/colorizer'

"=== Snippets ===
Plug 'SirVer/ultisnips'

"=== Code ===
" Syntax checking
Plug 'scrooloose/syntastic'
" Autoclose brakets etc.
Plug 'raimondi/delimitmate'
" python"
Plug 'nvie/vim-flake8'
Plug 'davidhalter/jedi-vim'
" Class/module browser
Plug 'majutsushi/tagbar'

" Side Tree view
Plug 'scrooloose/nerdtree'
" Project
Plug 'ctrlpvim/ctrlp.vim'
" Better commenting
Plug 'scrooloose/nerdcommenter'

"=== Efficiency ===
" Surround objects with text
Plug 'tpope/vim-surround'
" Formatting content
Plug 'godlygeek/tabular'

"=== VCS ===
" Git/mercurial/others diff icons on the side of the file lines
Plug 'mhinz/vim-signify'
" Git support
Plug 'tpope/vim-fugitive'

"=== Writing ===
" Distraction free writing
Plug 'junegunn/goyo.vim'
" Light only active paragraph
Plug 'junegunn/limelight.vim'
" Markdown and Pandoc support
"Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
" Plug 'vim-pandoc/vim-pandoc'
" More Pandoc support
" Plug 'vim-pandoc/vim-pandoc-syntax'
" Table mode for use in markdown
"Plug 'dhruvasagar/vim-table-mode'

call plug#end()

" ============================================================================
" Install plugins the first time vim runs
if vim_plug_just_installed
echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif


filetype plugin indent on

"set term=screen-256color

let python_highlight_all=1

set autoindent
set bg=dark
set background=dark
set backspace=indent,eol,start
set expandtab
set ignorecase
set incsearch
set laststatus=2
set linebreak
set nobackup
set noerrorbells
set nolist
set noswapfile
set novb
set wrap
set tw=80
set number
set relativenumber
set ruler
set scrolloff=15
set showmatch
set shiftwidth=2
set shortmess=I
set showcmd
set showmode
set sidescroll=1
set sidescrolloff=7
set smartcase
set softtabstop=2
set undolevels=1000

" change the mapleader from \ to ,
let mapleader=","

"=== AIRLINE CONFIGS ===
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1


"NERDTree
map <C-n> :NERDTreeToggle<CR>

" Switch in buffers more easily
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Remove all trailing whitespace by pressing F4
noremap <F4> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Tagbar --------------------------------
" toggle tagbar display
map <F5> :TagbarToggle<CR>
" autofocus on tagbar open
let g:tagbar_autofocus = 1

" Python run with F9
nnoremap <buffer> <F9> :exec '!python2' shellescape(@%, 1)<cr>

" Jedi-vim ------------------------------
" All these mappings work only for python code:
" Go to definition
let g:jedi#goto_command = ',d'
" Find ocurrences
let g:jedi#usages_command = ',o'
" Find assignments
let g:jedi#goto_assignments_command = ',a'
" Go to definition in new tab
nmap ,D :tab split<CR>:call jedi#goto()<CR>

" Signify ------------------------------
" this first setting decides in which order try to guess your current vcs
" UPDATE it to reflect your preferences, it will speed up opening files
let g:signify_vcs_list = [ 'git' ]
" mappings to jump to changed blocks
nmap <leader>sn <plug>(signify-next-hunk)
nmap <leader>sp <plug>(signify-prev-hunk)


" Pandoc settings -----------------------
" let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
" let g:pandoc#filetypes#pandoc_markdown = 0
" let g:pandoc#command#autoexec_command = "Pandoc! pdf"


" Tabularize
" inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

"let g:table_mode_corner_corner='+'
"let g:table_mode_header_fillchar='='

" Cursor Modes
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

" Exit insert mode more elegantly
set timeoutlen=300
inoremap fj <Esc>l
inoremap jf <Esc>l

" more colors
"set termguicolors
"
colorscheme PaperColor
