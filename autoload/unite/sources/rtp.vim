let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = { 
      \ "name": 'rtp',
      \ "hooks": {},
      \ }

function! s:unite_source.gather_candidates(args, context)"{{{
  let candidates = []
  for [linum, path] in map(split(&rtp,","),'[v:key+1, v:val]')
    call add(candidates, {
          \ "word": printf("%3d: %s", linum, path),
          \ "kind": "directory",
          \ "action__directory": fnamemodify(path, ":p"),
          \ "action__path": fnamemodify(path, ":p"),
          \ })
  endfor
  return candidates
endfunction"}}}

function! unite#sources#rtp#define()"{{{
  return s:unite_source
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker:
