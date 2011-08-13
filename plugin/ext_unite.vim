" GUARD: {{{
"============================================================
if exists('g:loaded_ext_unite')
  finish
endif

let g:loaded_ext_unite = 1
let s:old_cpo = &cpo
set cpo&vim
" }}}

" Purpose:
" converter_relative_word, converter_relative_abbr 使用時に eでの絞り込みは
" word でやりたいので。
function! s:narrowing_word()"{{{
  if line('.') <= unite#get_current_unite().prompt_linenr
    return
  endif
  let l:candidate = unite#get_current_candidate()
  call unite#mappings#narrowing(l:candidate.word)
endfunction"}}}

nnoremap <silent> <Plug>(ext_unite_narrowing_word)  :<C-u>call <SID>narrowing_word()<CR>

" Purpose: 
" 前提: preview window は使用せず、persist_open アクションを多用している。
" persist_open は 元々いた window に開くので、そこを unite からスクロールしたい。
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

" function! s:toggle_auto_persist_open()"{{{
"   if exists("b:ext_unite_auto_persist_open")
"         \ && b:ext_unite_auto_persist_open
"     nnoremap
" 
"   endif
"   let l:context = unite#get_context()
"   let l:context.auto_preview = !l:context.auto_preview
" 
"   if !l:context.auto_preview
"         \ && !unite#get_current_unite().has_preview_window
"     " Close preview window.
"     pclose!
"   endif
" endfunction"}}}


let &cpo = s:old_cpo
" vim: foldmethod=marker
