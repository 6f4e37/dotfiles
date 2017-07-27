" -----------------------------------------------------------------------------
" Name: vimrc
" Description: Config file for vim
" Location: $HOME/.vimrc
" -----------------------------------------------------------------------------

" Environment {{{
" -----------------------------------------------------------------------------
" vimconf is not vi-compatible
if &compatible
    set nocompatible
endif

" Paths {{{
" If XDG_CONFIG_HOME has not been set, set to '$HOME/.config'
if empty($XDG_CONFIG_HOME)
  let $XDG_CONFIG_HOME = $HOME . '/.config'
endif

" Create vim config directory
if !isdirectory($XDG_CONFIG_HOME . "/vim")
  call mkdir($XDG_CONFIG_HOME . "/vim", "p")
endif

" Make vim respect XDG standards
set runtimepath-=$HOME/.vim
set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath-=$HOME/.vim/after
set runtimepath+=$XDG_CONFIG_HOME/vim/after

" files to search
set path=.,**

" Set to auto read when a file is changed from the outside
set autoread
" Automatically switch to file directory of buffer
set autochdir
" }}}

" Cache {{{
" If XDG_CACHE_HOME has not been set, set to '$HOME/.cache'
if empty($XDG_CACHE_HOME)
  let $XDG_CACHE_HOME = $HOME . "/.cache"
endif

" Create vim cache directory
if !isdirectory($XDG_CACHE_HOME . "/vim")
  call mkdir($XDG_CACHE_HOME . "/vim", "p")
endif

" Create vim swap location
if !isdirectory($XDG_CACHE_HOME . "/vim/swap")
  call mkdir($XDG_CACHE_HOME . "/vim/swap")
endif
set directory=$XDG_CACHE_HOME/vim/swap//,/var/tmp//,/tmp//

" create backupdir incase backup is set
if !isdirectory($XDG_CACHE_HOME . "/vim/backup")
  call mkdir($XDG_CACHE_HOME . "/vim/backup")
endif
set backupdir=$XDG_CACHE_HOME/vim/backup//,/var/tmp//,/tmp//
" disable backups by default
set nobackup

" enable undofile
if has('persistent_undo')
    if !isdirectory($XDG_CACHE_HOME . "/vim/undo")
        call mkdir($XDG_CACHE_HOME . "/vim/undo")
    endif
    set undodir=$XDG_CACHE_HOME/vim/undo//,/var/tmp//,/tmp//
    set undofile
endif
" number of undos to keep
set undolevels=1000

" 10 marks, 100 searches, 1000 commands, 10 lines / register, 10 inputs,
"   10kb max size of item, disable hlsearch on start, viminfo file name
set viminfo='10,/100,:1000,<10,@10,s10,h,n$XDG_CACHE_HOME/vim/.viminfo
" Number of command lines to remember
set history=1000

" spellfile
set spellfile=$XDG_CACHE_HOME/en.utf-8.add
" disable spelling by default
set nospell
" }}}

" Encoding {{{
" if encoding is not utf-8 set termencoding
if &encoding !=? 'utf-8'
    let &termencoding = &encoding
endif

" Set utf8 as standard encoding
set encoding=utf-8
set fileencoding=utf-8

" Use unix as the standard file type
set fileformats=unix,mac,dos
" }}}

" -----------------------------------------------------------------------------
" }}}

" Plugins {{{
" -----------------------------------------------------------------------------
" vim-plug plugin manager
call plug#begin($XDG_CONFIG_HOME . "/vim/plugged")

" colorscheme
" Plug 'morhetz/gruvbox'

" buffers in tabline
Plug 'ap/vim-buftabline'

" split width fixer
Plug 'roman/golden-ratio'

" completion engine
Plug 'ajh17/VimCompletesMe'

" align everything
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }

" check syntax
Plug 'w0rp/ale'

" text objects
Plug 'wellle/targets.vim'

" searching
Plug 'haya14busa/incsearch.vim'
Plug 'unblevable/quick-scope'

" racket language support
Plug 'wlangstroth/vim-racket', { 'for': ['racket'] }

" Automatically executes filetype plugin indent on and syntax enable
call plug#end()

" Enable filetype plugins
filetype plugin indent on

" ale {{{
" linter statusline format
let g:ale_statusline_format = ['%d error(s)', '%d warning(s)', '']

" messaging
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%severity%: %linter%] %s'
" }}}

" buftabline {{{
let g:buftabline_show = 1
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1
" }}}

" incsearch.vim {{{
" auto diable hlsearch on non search movement
let g:incsearch#auto_nohlsearch = 1
" }}}

" netrw {{{
let g:netrw_banner = 0
let g:netrw_list_hide = '^\.$'
let g:netrw_liststyle = 3
" }}}
" -----------------------------------------------------------------------------
" }}}

" Interface {{{
" -----------------------------------------------------------------------------
" window title
set title

" disable beep and flashing
set vb t_vb=

" Don't redraw while executing macros
set lazyredraw
" Faster redraws
set ttyfast

" Buffers and Splits {{{
" A buffer becomes hidden when it is abandoned
set hidden

" splits go below w/focus
set splitbelow
" vsplits go right w/focus
set splitright
" }}}

" Statusline {{{
if has('statusline')
    " always show statusline if able
    set laststatus=2
    " buffer number
    set statusline+=%4n

    " File name
    set statusline+=\ %<%F

    " read only flag
    set statusline+=%{&ro?'\ [≠]':''}

    " modified flag
    set statusline+=%{&mod?'\ [+]':''}

    " display a warning if fileformat isnt unix
    set statusline+=%{&ff!='unix'?'[ff:\ '.&ff.']':''}

    " display a warning if file encoding isnt utf-8
    set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'[ft:\ '.&fenc.']':''}

    " separate left/right side
    set statusline+=%=

    " syntax checking
    "set statusline+=%{exists('g:loaded_syntastic_plugin')?SyntasticStatuslineFlag():''}
    set statusline+=%{\ ALEGetStatusLine()}

    " Cursor info
    set statusline+=\ %c:%l
    set statusline+=\ %P\ 
endif
" }}}

" Messages {{{
" show cmds being typed if able
if has('cmdline_info')
    set showcmd
endif

" disable startup message
set shortmess+=I

" don't give ins-completion-menu messages
set shortmess+=c

" display the current mode
set showmode

" ---more--- like less
set more
" }}}

" Wildmenu {{{
" better auto complete
set wildmenu
" bash-like auto complete
set wildmode=longest,list,full
" dont display these kinds of files in wildmenu
set wildignore=*~
" vim temp files
set wildignore+=*.swp,*.swo
" git
set wildignore+=*.git
" Unix
set wildignore+=*/tmp/*,*.so,*DS_Store*,*.dmg
" Windows
set wildignore+=*\\tmp\\*,*.exe
" c
set wildignore+=*.a,*.o,*.so,*.obj
" python
set wildignore+=*.pyc
" ruby
set wildignore+=*.gem
" docs
set wildignore+=*.pdf
" archives
set wildignore+=*.zip
" pictures
set wildignore+=*.png,*.jpg,*.jpeg,*.gif
" directories
set wildignore+=*vim/cache*
set wildignore+=*sass-cache*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=log/**
set wildignore+=tmp/**

" scan current and included files for defined name or macro
set complete+=d
" }}}

" Search {{{
" Makes search act like modern browsers
set incsearch

" Enables highlighting of search results
set hlsearch

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" For regular expressions turn magic on
set magic
" }}}

" Folds {{{
" fold using syntax
set foldmethod=manual

" folds closed by default
set foldlevelstart=1

" hide folding column
set foldcolumn=0

" max 10 nested folds
set foldnestmax=10
" }}}

" Cursor {{{
" hilight cursor line
set cursorline

" keep cursor column pos
set nostartofline

" line numbers
set number
" 99999 lines
set numberwidth=5

" fix scrolling
set scrolloff=8
set sidescrolloff=15
set sidescroll=1

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2
" matching for ci< or ci>
set matchpairs+=<:>
" }}}

" Syntax {{{
" Enable syntax highlighting
syntax on

" we're using a dark bg
set background=dark

" use this colorscheme
colorscheme krul

" Highlight problematic whitespace
set list listchars=tab:>\ ,trail:_,extends:>,precedes:<,nbsp:~
set showbreak=\\

augroup syntax_trail
    au!
    au InsertEnter * :set listchars-=trail:_
    au InsertLeave * :set listchars+=trail:_
augroup END

" highlight trailing whitespace
highlight SpecialKey ctermbg=NONE ctermfg=DarkRed cterm=NONE
" }}}
" -----------------------------------------------------------------------------
" }}}

" Formatting {{{
" -----------------------------------------------------------------------------
" spaces instead of tabs
set expandtab
" Be smart when using tabs ;)
set smarttab

" indent stuff
set autoindent
set smartindent
set shiftround

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4
set nojoinspaces

" not word dividers
set iskeyword+=_,$,@,%,#

" dont wrap lines
set nowrap
" dont cut words on wrap
set linebreak
" autowrap with newline char
set formatoptions+=t
" delete comment when joining commented lines
set formatoptions+=j

" Sentences delimit by two spaces
set cpoptions+=J

" git {{{
augroup ft_git
    au!
    au FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
    au Filetype git,gitcommit setlocal spell tw=72
augroup END
" }}}

" C {{{
augroup ft_c
    au!
    au FileType c,cpp setlocal foldmethod=marker foldmarker={,}
    au FileType c,cpp setlocal nospell tw=79 ts=8 sts=8 sw=8 expandtab
augroup END
" }}}

" Python {{{
augroup ft_python
    au!
    au FileType python setlocal foldmethod=syntax foldlevel=1
    au FileType python setlocal nospell tw=79 ts=4 sts=4 sw=4 expandtab
augroup END
" }}}

" Text {{{
augroup ft_text
    au!
    au FileType markdown,text,txt setlocal spell tw=72 ts=4 sts=4 sw=4 noexpandtab
augroup END
" }}}
" -----------------------------------------------------------------------------
" }}}

" Mappings {{{
" -----------------------------------------------------------------------------
" fix escape key delay
set timeout
set timeoutlen=1000
set ttimeoutlen=100

" disable mouse
set mouse=

" Configure backspace so it acts as it should act
set backspace=indent,eol,start

" Conflicts when using mapleader so map space to \
map <space> <leader>

" Treat wrapped lines as normal lines
nnoremap j gj
nnoremap k gk

" toggle folds with enter
nnoremap <Enter> za

" Buffers
nnoremap <leader>b :ls<cr>:b<space>
nnoremap <leader>[ :bprevious<cr>
nnoremap <leader>] :bnext<cr>
" jump to alternate buffer
nnoremap <leader><space> <C-^>

" open horizontal / vertical window
nnoremap <leader>s <C-W>s
nnoremap <leader>v <C-W>v
" open file under cursor in vertal split
nnoremap <leader>f :vertical wincmd f<CR>
" close windows
nnoremap <leader>c <C-W>c
nnoremap <leader>q <C-W>q
nnoremap <leader>o :only<CR>
" Move between windows
nnoremap <leader>h <C-W>h
xnoremap <leader>h <C-W>h
nnoremap <leader>j <C-W>j
xnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
xnoremap <leader>k <C-W>k
nnoremap <leader>l <C-W>l
xnoremap <leader>l <C-W>l
" resize windows
nnoremap <leader>H <C-W><
xnoremap <leader>H <C-W><
nnoremap <leader>J <C-W>-
xnoremap <leader>J <C-W>-
nnoremap <leader>K <C-W>+
xnoremap <leader>K <C-W>+
nnoremap <leader>L <C-W>>
xnoremap <leader>L <C-W>>
nnoremap <leader>- <C-W>\|
xnoremap <leader>- <C-W>\|
nnoremap <leader>\| <C-W>_
xnoremap <leader>\| <C-W>_

" Edit
noremap <leader>e :e<space>
noremap <leader>es :sp<space>
noremap <leader>ev :vsp<space>

" better search
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
" Quicker search / replace
nnoremap <leader>* *``cgn
nnoremap <leader># #``cgN
nnoremap <leader>% :%s/\<<C-r>=expand("<cword>")<CR>\>/

" Change Y to be consistent with C and D
nnoremap Y y$

" yank/paste/delete to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>yy "+yy
nnoremap <leader>Y "+y$
nnoremap <leader>d "+d
nnoremap <leader>dd "+dd
nnoremap <leader>D "+D
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" select last changed block
nnoremap <leader>V `[v`]
" Go to the starting position after visual modes
vnoremap <ESC> o<ESC>
" don't exit visual mode while shifting
vnoremap < <gv
vnoremap > >gv

" reformat entire file
nnoremap <leader>= gg=G``
" Remove trailing whitespace
nnoremap <leader>w m`:%s/\s\+$//<CR>:let @/=''<CR>``
" alignment
nmap <leader>a <Plug>(EasyAlign)
xmap <leader>a <Plug>(EasyAlign)

" lets enter select items in popupmenu without newline
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" make single quote act like backtick
nnoremap ' `

" disable ex mode
nnoremap Q <Nop>
" disable keyword man page
nnoremap K <Nop>
" -----------------------------------------------------------------------------
" }}}

" vim:foldmethod=marker:foldlevel=0
