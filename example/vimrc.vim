command! Variables   :Unite variable
command! ScriptNames :Unite scriptnames
command! RTP         :Unite rtp
command! Function    :Unite function

autocmd FileType unite call s:filetype_unite_hook()
function! s:filetype_unite_hook()
  nmap <buffer> e   <Plug>(ext_unite_narrowing_word)
  nmap <buffer> f   <Plug>(ext_unite_scroll_previous_win_half_forward)
  nmap <buffer> b   <Plug>(ext_unite_scroll_previous_win_half_backward)

  nmap <buffer> C <Plug>(ext_unite_project_cd)

  " for persit_open action
  nmap <buffer> J    <Plug>(ext_unite_loop_cursor_down_w_persis_open)
  nmap <buffer> K    <Plug>(ext_unite_loop_cursor_up_w_persis_open)
  nmap <buffer> <F9> <Plug>(ext_unite_toggle_auto_persist_open)


  if b:unite.buffer_name =~# 'file_\d'
    nnoremap <silent> <buffer> <C-p>      :call g:unite_file_resume('previous')<CR>
    nnoremap <silent> <buffer> <C-n>      :call g:unite_file_resume('next')<CR>
    inoremap <silent> <buffer> <C-p> <C-o>:call g:unite_file_resume('previous')<CR>
    inoremap <silent> <buffer> <C-n> <C-o>:call g:unite_file_resume('next')<CR>
  endif

  if b:unite.buffer_name =~# 'file_rec_\d'
    nnoremap <silent> <buffer> <C-p>      :call g:unite_file_rec_resume('previous')<CR>
    nnoremap <silent> <buffer> <C-n>      :call g:unite_file_rec_resume('next')<CR>
    inoremap <silent> <buffer> <C-p> <C-o>:call g:unite_file_rec_resume('previous')<CR>
    inoremap <silent> <buffer> <C-n> <C-o>:call g:unite_file_rec_resume('next')<CR>
  endif
endfunction

function! Set_subtituite_pattern(buffer_name) "{{{
  " http://d.hatena.ne.jp/thinca/20101027/1288190498
  " 環境変数の展開
  call unite#set_substitute_pattern(a:buffer_name, '\$\w\+', '\=eval(submatch(0))', 200)
  call unite#set_substitute_pattern(a:buffer_name, '[^~.]\zs/', '*/*', 20)
  call unite#set_substitute_pattern(a:buffer_name, '/\ze[^*]', '/*', 10)

  " current file dir
  call unite#set_substitute_pattern(a:buffer_name, '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
  " current dir
  call unite#set_substitute_pattern(a:buffer_name, '^@', '\=getcwd()."/*"', 1)
  " home?
  call unite#set_substitute_pattern(a:buffer_name, '^\\', '~/*')

  " short cut
  call unite#set_substitute_pattern(a:buffer_name, '^;v', '~/.vim/*')
  call unite#set_substitute_pattern(a:buffer_name, '^;b', '~/.vim/bundle/*')
  call unite#set_substitute_pattern(a:buffer_name, '^;g', '/var/lib/gems/1.8/gems/*')
  call unite#set_substitute_pattern(a:buffer_name, '^;r', '\=$VIMRUNTIME."/*"')
  call unite#set_substitute_pattern(a:buffer_name, '^;c', '~/local/chef/cookbooks/*')
  call unite#set_substitute_pattern(a:buffer_name, '^;n', '~/local/github/openstack/')

  call unite#set_substitute_pattern(a:buffer_name, '\*\*\+', '*', -1)
  call unite#set_substitute_pattern(a:buffer_name, '^\~', escape($HOME, '\'), -2)
  " call unite#set_substitute_pattern(a:buffer_name, '\\\@<! ', '\\ ', -20)
  " call unite#set_substitute_pattern(a:buffer_name, '\\ \@!', '/', -30)
endfunction "}}}
call Set_subtituite_pattern("file")

" history {{{
let s:unite_file = unite#file_with_history#new("file", function("Set_subtituite_pattern") )
function! g:unite_file(...)
  call call(s:unite_file.launch, a:000, s:unite_file)
endfunction
function! g:unite_file_resume(direction)
  call s:unite_file.resume(a:direction)
endfunction

command! -nargs=* -complete=dir File :call g:unite_file(<f-args>)
nnoremap <silent> <Space>f  :<C-u> File<CR>

" file_rec:
let s:unite_file_rec = unite#file_with_history#new("file_rec", function("Set_subtituite_pattern") )
function! g:unite_file_rec(...)
  call call(s:unite_file_rec.launch, a:000, s:unite_file_rec)
endfunction
function! g:unite_file_rec_resume(direction)
  call s:unite_file_rec.resume(a:direction)
endfunction
command! -nargs=* -complete=dir FileRec :call g:unite_file_rec(<f-args>)
nnoremap <silent> <Space>F  :<C-u> FileRec<CR>
" }}}

