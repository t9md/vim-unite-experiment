" GUARD: {{{
"============================================================
" if exists('g:loaded_ext_unite')
  " finish
" endif

let g:loaded_ext_unite = 1
let s:old_cpo = &cpo
set cpo&vim
" }}}

function! s:narrowing_word()"{{{
  if line('.') <= unite#get_current_unite().prompt_linenr
    return
  endif
  let l:candidate = unite#get_current_candidate()
  call unite#mappings#narrowing(l:candidate.word)
endfunction"}}}

nnoremap <silent> <Plug>(ext_unite_narrowing_word)  :<C-u>call <SID>narrowing_word()<CR>

function! s:scroll_prevwin(key, amount)
  let context = unite#get_context()
  echo context
  let height = winheight(context.winnr)

  let movement = a:amount == "half"
        \ ? repeat(a:key, height/2)
        \ : repeat(a:key, height)
  return "\<C-w>p" . movement . "\<C-w>p"
endfunction

nnoremap <silent><expr> <Plug>(ext_unite_scroll_prevwin_half_forward) <SID>scroll_prevwin("\<C-e>","half")
nnoremap <silent><expr> <Plug>(ext_unite_scroll_prevwin_half_backward) <SID>scroll_prevwin("\<C-y>","half")


let &cpo = s:old_cpo
" vim: foldmethod=marker
