" GUARD: {{{
"============================================================
if exists('g:loaded_ext_unite')
  finish
endif

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

let &cpo = s:old_cpo
" vim: foldmethod=marker
