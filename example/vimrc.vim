command! Variables   :Unite variable
command! ScriptNames :Unite scriptnames
command! RTP         :Unite rtp
command! Function    :Unite function

let g:unite_force_overwrite_statusline=0
autocmd FileType unite call s:filetype_unite_hook()
function! s:filetype_unite_hook()
  " nmap <buffer> e   <Plug>(ext_unite_narrowing_word)
  nmap <buffer> f   <Plug>(ext_unite_scroll_previous_win_half_forward)
  nmap <buffer> b   <Plug>(ext_unite_scroll_previous_win_half_backward)

  nmap <buffer> C <Plug>(ext_unite_project_cd)

  " for persit_open action
  nmap <buffer> J    <Plug>(ext_unite_loop_cursor_down_w_persis_open)
  nmap <buffer> K    <Plug>(ext_unite_loop_cursor_up_w_persis_open)
  nmap <buffer> <F9> <Plug>(ext_unite_toggle_auto_persist_open)

  if b:unite.buffer_name =~# 'file_rec_\d'
    nmap <buffer> <D-[> <Plug>(ext-unite-with_history-file_rec-p)
    nmap <buffer> <D-]> <Plug>(ext-unite-with_history-file_rec-n)
    imap <buffer> <D-[> <Plug>(ext-unite-with_history-file_rec-p)
    imap <buffer> <D-]> <Plug>(ext-unite-with_history-file_rec-n)
  endif
  if b:unite.buffer_name =~# 'file_rec/async_\d'
    nmap <buffer> <D-[> <Plug>(ext-unite-with_history-file_rec/async-p)
    nmap <buffer> <D-]> <Plug>(ext-unite-with_history-file_rec/async-n)
    imap <buffer> <D-[> <Plug>(ext-unite-with_history-file_rec/async-p)
    imap <buffer> <D-]> <Plug>(ext-unite-with_history-file_rec/async-n)
  endif
  setlocal statusline=%{b:unite.buffer_name}\ :\ %{unite#get_status_string()}
endfunction


call unite#with_history#setup("file_rec", "FileRec")
" 1st arg: unite's source_name, 2nd arg: command name to be defined
" by calling this
"  - command FileRec 
"  - mapping 
"      nnoremap <Plug>(ext-unite-with_history-file_rec-p)
"      nnoremap <Plug>(ext-unite-with_history-file_rec-n)
"      inoremap <Plug>(ext-unite-with_history-file_rec-p)
"      inoremap <Plug>(ext-unite-with_history-file_rec-n)

call unite#with_history#setup("file_rec/async", "FileRecAsync")
" 1st arg: unite's source_name, 2nd arg: command name to be defined
" by calling this
"  - command FileRecAsync
"  - mapping 
"      nnoremap <Plug>(ext-unite-with_history-file_rec/async-p)
"      nnoremap <Plug>(ext-unite-with_history-file_rec/async-n)
"      inoremap <Plug>(ext-unite-with_history-file_rec/async-p)
"      inoremap <Plug>(ext-unite-with_history-file_rec/async-n)


nnoremap <silent> <Space>f   :<C-u>FileRecAsync<CR>
nnoremap <silent> <Space>r   :<C-u>FileRecAsync ~/.vim/bundle<CR>
nnoremap <silent> <Space>F   :<C-u>exe "FileRecAsync " . expand('%:p:h')<CR>

