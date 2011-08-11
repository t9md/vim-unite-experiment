let s:save_cpo = &cpo
set cpo&vim

" UTILITY:
function! s:variables(scope) "{{{
  let scopes = {
        \ "buffer": b:,
        \ "window": w:,
        \ "tabpage": t:,
        \ "global": g:,
        \ "script": s:,
        \ "vim": v:,
        \ }
    let candidates = []
    for [varname, Tmp] in items(scopes[a:scope])
      let Val = 
            \ type(Tmp) == type({}) ? "::DICT::" :
            \ type(Tmp) == type([]) ? "::LIST::" :
            \ Tmp

      call add(candidates, { 
            \ "word": printf("%-30s - %s", varname, string(Val) ),
            \ "kind": "command",
            \ })
      unlet! Tmp
      unlet! Val
    endfor
    return candidates
endfunction"}}}

" TEMPLATE:
let s:tmpl = { "hooks": {} }
function! s:tmpl.gather_candidates(args, context)"{{{
  return a:context.source__vars
endfunction"}}}
function! s:tmpl.hooks.on_init(args, context) "{{{
  let scope = split(a:context.source.name, "/")[-1]
  let a:context.source__vars = s:variables(scope)
endfunction"}}}

" MAIN:
let scopes = [ "buffer" , "window", "tabpage", "global", "script", "vim" ]
let s:source_names = map( copy(scopes), '"var/" . v:val ')
function! unite#sources#var#define()"{{{
  let sources = []
  for source_name in s:source_names
    call add( sources,
          \ extend(copy({"name": source_name} ), deepcopy(s:tmpl), 'force')
          \ )
  endfor
  return sources
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker:
