" Vim script to work like "less"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2001 May 03

set nocp
syntax on
set so=0
set hlsearch
set incsearch
nohlsearch

" Used after each command: put cursor at end and display position
if &wrap
  noremap <SID>L L$:file<CR>
  au VimEnter * normal L$
else
  noremap <SID>L Lg$:file<CR>
  au VimEnter * normal Lg$
endif

" When reading from stdin don't consider the file modified.
au VimEnter * set nomod

" Can't modify the text
set noma

" Give help
noremap h :call <SID>Help()<CR>
map H h
fun! s:Help()
  echo "<Space>   One page forward          b         One page backward"
  echo "d         Half a page forward       u         Half a page backward"
  echo "<Enter>   One line forward          k         One line backward"
  echo "G         End of file               g         Start of file"
  echo "N%        percentage in file"
  echo "\n"
  echo "/pattern  Search for pattern"
  echo "n         next pattern match        N         Previous pattern match"
  echo "\n"
  echo ":n<Enter> Next file                 :p<Enter> Previous file"
  echo "\n"
  echo "q         Quit                      v         Edit file"
  let i = input("Hit Enter to continue")
endfun

" Scroll one page forward
noremap <script> <Space> :call <SID>NextPage()<CR><SID>L
map <C-V> <Space>
map f <Space>
map <C-F> <Space>
map z <Space>
map <Esc><Space> <Space>
fun! s:NextPage()
  if line(".") == line("$")
    if argidx() + 1 >= argc()
      quit
    endif
    next
    1
  else
    exe "normal! \<C-F>"
  endif
endfun

" Re-read file and page forward "tail -f"
map F :e<CR>G<SID>L:sleep 1<CR>F

" Scroll half a page forward
noremap <script> d <C-D><SID>L
map <C-D> d

" Scroll one line forward
noremap <script> <CR> <C-E><SID>L
map <C-N> <CR>
map e <CR>
map <C-E> <CR>
map j <CR>
map <C-J> <CR>

" Scroll one page backward
noremap <script> b <C-B><SID>L
map <C-B> b
map w b
map <Esc>v b

" Scroll half a page backward
noremap <script> u <C-U><SID>L
noremap <script> <C-U> <C-U><SID>L

" Scroll one line backward
noremap <script> k <C-Y><SID>L
map y k
map <C-Y> k
map <C-P> k
map <C-K> k

" Redraw
noremap <script> r <C-L><SID>L
noremap <script> <C-R> <C-L><SID>L
noremap <script> R <C-L><SID>L

" Start of file
noremap <script> g gg<SID>L
map < g
map <Esc>< g

" End of file
noremap <script> G G<SID>L
map > G
map <Esc>> G

" Go to percentage
noremap <script> % %<SID>L
map p %

" Next pattern
noremap <script> n n<SID>L
noremap <script> N N<SID>L

" Quitting
noremap q :q<CR>

" Switch to editing (switch off less mode)
map v :call <SID>End()<CR>
fun! s:End()
  set ma
  unmap h
  unmap H
  unmap <Space>
  unmap <C-V>
  unmap f
  unmap <C-F>
  unmap z
  unmap <Esc><Space>
  unmap F
  unmap d
  unmap <C-D>
  unmap <CR>
  unmap <C-N>
  unmap e
  unmap <C-E>
  unmap j
  unmap <C-J>
  unmap b
  unmap <C-B>
  unmap w
  unmap <Esc>v
  unmap u
  unmap <C-U>
  unmap k
  unmap y
  unmap <C-Y>
  unmap <C-P>
  unmap <C-K>
  unmap r
  unmap <C-R>
  unmap R
  unmap g
  unmap <
  unmap <Esc><
  unmap G
  unmap >
  unmap <Esc>>
  unmap %
  unmap p
  unmap n
  unmap N
  unmap q
  unmap v
endfun