let s:save_cpo = &cpo
set cpo&vim

function! s:scriptnames()"{{{
  redir => _
  silent scriptnames
  redir END
  return split(_, '\n')
endfunction"}}}

let s:unite_source = { 
      \ "name": 'scriptnames',
      \ "hooks": {},
      \ }

function! s:unite_source.gather_candidates(args, context)"{{{
  let candidates = []
  for line in s:scriptnames()
    let [linum, path] = matchlist(line, '\v\s*(\d+):\s*(.*)')[1:2]
    call add(candidates, {
          \ "word": path,
          \ "abbr": printf("%3d: %s", linum, path),
          \ "kind": "file",
          \ "action__path": fnamemodify(path, ":p"),
          \ "source": "scriptnames",
          \ })
  endfor
  return candidates
endfunction"}}}

function! unite#sources#scriptnames#define()"{{{
  return s:unite_source
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker:
