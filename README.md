Unite で試行錯誤、自分用の設定とか。  
Personal setting for unite.vim


## .vimrc の設定

    command! Variables   :Unite -buffer-name=variable var/buffer var/window var/tabpage var/global var/script var/vim
    command! ScriptNames :Unite scriptnames

    autocmd FileType unite call s:filetype_unite_hook()
    function! s:filetype_unite_hook()
      nmap <buffer> e   <Plug>(ext_unite_narrowing_word)
      nmap <buffer> f   <Plug>(ext_unite_scroll_previous_win_half_forward)
      nmap <buffer> b   <Plug>(ext_unite_scroll_previous_win_half_backward)

      " for persit_open action
      nmap <buffer> J    <Plug>(ext_unite_loop_cursor_down_w_persis_open)
      nmap <buffer> K    <Plug>(ext_unite_loop_cursor_up_w_persis_open)
      nmap <buffer> <F9> <Plug>(ext_unite_toggle_auto_persist_open)
    endfunction
