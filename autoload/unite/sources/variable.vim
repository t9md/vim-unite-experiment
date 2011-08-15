let s:save_cpo = &cpo
set cpo&vim

function! s:variables() "{{{
  let scopes = ["b:", "w:", "t:", "g:", "s:", "v:"]

  let candidates = []
  for scope in scopes
    for [varname, Tmp] in items(eval(scope))
      let Val = 
            \ type(Tmp) == type({}) ? "::DICT::" :
            \ type(Tmp) == type([]) ? "::LIST::" :
            \ Tmp

      call add(candidates, { 
            \ "word": printf("%-35s - %s", scope . varname, string(Val) ),
            \ "kind": "command",
            \ })
      unlet! Tmp
      unlet! Val
    endfor
  endfor
  return candidates
endfunction"}}}

let s:unite_source = { 
      \ "name": "variable",
      \ "hooks": {},
      \ }

function! s:unite_source.gather_candidates(args, context) "{{{
  return a:context.source__vars
endfunction "}}}

function! s:unite_source.hooks.on_init(args, context) "{{{
  let a:context.source__vars = s:variables()
endfunction "}}}

function! unite#sources#variable#define() "{{{
  return s:unite_source
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker:
