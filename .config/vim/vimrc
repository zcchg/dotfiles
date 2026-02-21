" unset vim settings
  set nocompatible noautoread hidden nobackup writebackup undofile viminfo='10,f0,<100,s1000,:100,h
  let g:loaded_netrw=1 | let g:loaded_netrwPlugin=1
  autocmd! | " remove all autocmds

" paths
  let c=expand('~/.cache/vim')|for d in ['swp','backup','undo','view']|call mkdir(c.'/'.d,'p')|endfor
  let &viminfofile=c.'/viminfo'
  let &directory=c.'/swp'|let &backupdir=c.'/backup'|let &undodir=c.'/undo'|let &viewdir=c.'/view'
  let &runtimepath=expand('~').'/.config/vim/runtime,'.$VIMRUNTIME

" indentation
  filetype plugin indent on
  set tabstop=4
  autocmd BufNewFile,BufRead * if empty(&filetype) | set ts=2 sw=2 sts=2 et | endif
  autocmd FileType text,markdown,json,sh,zsh,css,js,vim set ts=2 sw=2 sts=2 et
  autocmd FileType * setlocal formatoptions-=cro " don't continue comment on the next line

" keys, layout, search, menu
  set timeoutlen=250             " key timeout
  set backspace=indent,eol,start " backspace through everything
  set scrolloff=5                " show the following 5 lines while scrolling
  set number cursorline          " show the number column and highlight the current line
  set laststatus=2               " always show status line
  set statusline=%f%=%c\ %l/%L   " filename, spacer, cursor position, current line/line count
  set hlsearch noincsearch       " highlight all matches but don't search while typing
  set ignorecase smartcase       " case-insensitive searching unless query contains uppercase
  set wildmenu wildmode=longest:full,full completeopt=menu,preview " completion

" theme
  let appearance = 'Dark' " system('defaults read -g AppleInterfaceStyle 2>/dev/null')
  try | if appearance =~ 'Dark' | colorscheme yin | else | colorscheme yang | endif | catch | endtry
  if appearance =~ 'Dark' | set background=dark | else | set background=light | endif

" save and restore functions (forbid invalid filenames, strip whitespace, restore cursor position)
  autocmd BufWritePre ["':;]* throw 'Forbidden filename: ' . expand('<afile>')
  autocmd BufWritePre * :let b:w=winsaveview() | :%s/\s\+$//e | :call winrestview(b:w) | :unlet b:w
  autocmd BufReadPost *
  \ if line("'\"") >= 0 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
