" Setting some decent VIM settings for programming

if &compatible
  " vi compatible is not necessary
  set nocompatible
endif

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  set t_ut=
endif

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
  " encoding for the file with utf-8 priority
  set fileencodings=utf-8,ucs-bom,latin1
endif

if has("multi_byte")
  " use utf-8 encoding
  set encoding=utf-8
  set termencoding=utf-8
  scriptencoding utf-8
endif

" The terminal with colors
set background=dark                 " use colours that work well on a dark background (console is usually black)

" General configurations
set ffs=unix,mac,dos                " use Unix as the standard file type
set title                           " change the terminal's title
set visualbell                      " turn on the 'visual bell' - which is much quieter than the 'audio blink'
set noerrorbells                    " don't beep on errors
set ruler                           " show the cursor position all the time
set laststatus=2                    " make the last line where the status is two lines deep so you can see status always
set backspace=indent,eol,start      " make that backspace key work the way it should
set showmode                        " show the current mode
set clipboard=unnamed               " set clipboard to unnamed to access the system clipboard under windows
set bs=indent,eol,start             " allow backspacing over everything in insert mode
set wildmenu                        " display completion matches in a status line
set wildmode=list:longest,list:full " configure the list
set number                          " show line numbers
set relativenumber                  " show relative line numbers
set autoread                        " set to auto read when a file is changed from the outside
set nowrap                          " don't wrap lines

" set backup and keep a backup file
set viminfo='20,\"50,h,%            " read/write a .viminfo file, don't store more than 50 lines of registers
set history=1000                    " keep 1000 lines of command line history

" syntax configurations
set path+=**                        " search down into subfolders
set hlsearch                        " highlight searches without moving
set incsearch                       " do incremental searching
set showcmd                         " display incomplete commands
set ignorecase                      " ignore case when searching
set smartcase                       " ignore case if search pattern is all lowercase
set shiftwidth=2                    " number of spaces to use for autoindenting
set softtabstop=2                   " keep the default tab stop size
set tabstop=2                       " a tab is two spaces
set smarttab                        " replace tab characters
set expandtab                       " use spaces instead of tabs
set shiftround                      " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch                       " automatically show matching brackets. works like it does in bbedit.
set autoindent                      " set auto-indenting on for programming
set copyindent                      " copy the previous indentation on autoindenting
set smartindent                     " set smart-indenting on for programming
set cindent                         " stricter rules for C programs
set magic                           " for regular expressions turn magic on

" show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P

" Vim5 and later versions support syntax highlighting.
if has("syntax")
  syntax on
endif

" set extra options when running in GUI mode
if has("gui_running")
  set guioptions-=T                 " remove toolbar
  set guioptions+=e                 " add tab pages
  set t_Co=256                      " use 256 colors
  set term=xterm-256color           " use xterm scheme
  set guitablabel=%M%t              " show the file name
  set guicursor+=n-v-c:blinkon0     " make the cursor blink
endif

" only do this part when compiled with support for autocommands.
if has("autocmd")
  " set UTF-8 as the default encoding for commit messages
  autocmd BufReadPre COMMIT_EDITMSG,MERGE_MSG,git-rebase-todo setlocal fileencodings=utf-8,ucs-bom,latin1

  " do not expand tabs for makefiles
  autocmd FileType make set noexpandtab

  " for git commit: line lenght to 62 chars and spell check
  autocmd Syntax gitcommit setlocal textwidth=62 spell spelllang=en_us

  " remember the positions in files with some git-specific exceptions"
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$")
    \           && expand("%") !~ "COMMIT_EDITMSG"
    \           && expand("%") !~ "MERGE_EDITMSG"
    \           && expand("%") !~ "ADD_EDIT.patch"
    \           && expand("%") !~ "addp-hunk-edit.diff"
    \           && expand("%") !~ "git-rebase-todo" |
    \   exe "normal g`\"" |
    \ endif

  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp,BufRead *.patch set filetype=diff
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec,BufRead *.diff set filetype=diff

  autocmd Syntax diff
    \ highlight WhiteSpaceEOL ctermbg=red |
    \ match WhiteSpaceEOL /\(^+.*\)\@<=\s\+$/
endif

if has("cscope")
  " use both cscope and ctag
  set cscopetag
  " check cscope for definition of a symbol before checking ctags
  set csto=0
  " use :cstag instead of the default :tag behavior
  set cst

  " reset the verbosity before adding a database
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
  " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  " place the verbosity back once the database is added
  set csverb
endif

if has("mouse")
  " enable the mouse in all modes
  set mouse=a
endif

" source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" enable file type detection.
filetype plugin indent on

