Unite で試行錯誤、自分用の設定とか。  
Personal setting for unite.vim


## .vimrc の設定

    command! Variables   :Unite -buffer-name=variable var/buffer var/window var/tabpage var/global var/script var/vim
    command! ScriptNames :Unite scriptnames

    autocmd FileType unite call s:filetype_unite_hook()
    function! s:filetype_unite_hook()
      nmap <buffer> e   <Plug>(ext_unite_narrowing_word)
      nmap <buffer> f   <Plug>(ext_unite_scroll_prevwin_half_forward)
      nmap <buffer> b   <Plug>(ext_unite_scroll_prevwin_half_backward)
    endfunction
