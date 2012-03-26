" how to use the project file:
"
" alias vvn="if [ -f project.vim ]; then gvim --servername GVIM -S project.vim; else gvim --servername GVIM; fi"
" alias vv="gvim --servername GVIM --remote-tab"
" vvn - starts new vim and loads this configuration
" vv - open file in a new tab
" 

" waf + vala project setup (F9 = compile)
set si
set makeprg=./waf
set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
map <F7> :cclose<Return>
map <F8> :copen<Return>
"map <F9> :wa<Return>:cclose<Return>:silent make<Return>:echo "Finished ok!"<Return>
map <F9> :wa<Return>:cclose<Return>:make<Return>
map <F10> :cprevious<Return>
map <F11> :cnext<Return>

" optional for syntactic plugin owners
let g:syntastic_vala_modules = 'glib-2.0 gobject-2.0 gtk+-3.0 vte-2.90'
let g:syntastic_vala_check_disabled=1
