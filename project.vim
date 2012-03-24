" waf + vala project setup (F9 = compile)
set si
set makeprg=./waf
set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
map <F7> :cclose<Return>
map <F8> :copen<Return>
map <F9> :wa<Return>:cclose<Return>:silent make<Return>:echo "Finished ok!"<Return>
map <F10> :cprevious<Return>
map <F11> :cnext<Return>

" optional for syntactic plugin owners
let g:syntastic_vala_check_disabled=1
