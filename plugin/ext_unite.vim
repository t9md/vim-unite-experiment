" GUARD: {{{
"============================================================
if exists('g:loaded_ext_unite')
  finish
endif

let g:loaded_ext_unite = 1
let s:old_cpo = &cpo
set cpo&vim
" }}}

" Subject: 常に word で narrowing するキーマップ
" Purpose:
" converter_relative_word, converter_relative_abbr 使用時。
" e での絞り込みは action__path ではなく word でやりたい。
"==================================================================
function! s:narrowing_word()"{{{
  if line('.') <= unite#get_current_unite().prompt_linenr
    return
  endif
  let l:candidate = unite#get_current_candidate()
  call unite#mappings#narrowing(l:candidate.word)
endfunction"}}}

" inoremap <silent> <Plug>(ext_unite_narrowing_word)  <C-o>:<C-u>call <SID>narrowing_word()<CR>
nnoremap <silent> <Plug>(ext_unite_narrowing_word)       :<C-u>call <SID>narrowing_word()<CR>

" Subject: unite を起動した window を unite バッファからスクロールする。
" Purpose: 
" 前提: 私は preview window は使用せず、persist_open アクションを多用している。
" persist_open は 元々いた window に開くので、そこを unite からスクロールしたい。
"==================================================================
function! s:scroll_previous_window(key, amount)"{{{
  let winnr = unite#get_current_unite().winnr
  let height = winheight(winnr)

  let movement = a:amount == "half"
        \ ? repeat(a:key, height/2)
        \ : repeat(a:key, height)
  return "\<C-w>p" . movement . "\<C-w>p"
endfunction"}}}

nnoremap <silent><expr> <Plug>(ext_unite_scroll_previous_win_half_forward)   <SID>scroll_previous_window("\<C-e>", "half")
nnoremap <silent><expr> <Plug>(ext_unite_scroll_previous_win_half_backward)  <SID>scroll_previous_window("\<C-y>", "half")

" Subject: persist_open アクションにに対応するキーマップの定義
"==================================================================
nnoremap <silent><expr> <Plug>(ext_unite_persist_open) unite#do_action('persist_open')

nmap <Plug>(ext_unite_loop_cursor_down_w_persis_open) <Plug>(unite_loop_cursor_down)<Plug>(ext_unite_persist_open)
nmap <Plug>(ext_unite_loop_cursor_up_w_persis_open) <Plug>(unite_loop_cursor_up)<Plug>(ext_unite_persist_open)

" Subject: project_cd アクションにに対応するキーマップの定義
"==================================================================
nnoremap <silent><expr> <Plug>(ext_unite_project_cd) unite#do_action('project_cd')

" Subject: <Plug>(unite_toggle_auto_preview) の persist_open 版 
"==================================================================
function! s:toggle_auto_persist_open()"{{{
 if !exists("b:ext_unite_auto_persist_open") || !b:ext_unite_auto_persist_open
   let b:ext_unite_auto_persist_open = 1

   nmap <buffer>j <Plug>(ext_unite_loop_cursor_down_w_persis_open)
   nmap <buffer>k <Plug>(ext_unite_loop_cursor_up_w_persis_open)
 else
   let b:ext_unite_auto_persist_open = 0
   nmap <buffer>j <Plug>(unite_loop_cursor_down)
   nmap <buffer>k <Plug>(unite_loop_cursor_up)
 endif
endfunction"}}}
nnoremap <silent><expr> <Plug>(ext_unite_toggle_auto_persist_open) <SID>toggle_auto_persist_open()

let &cpo = s:old_cpo
" vim: foldmethod=marker
