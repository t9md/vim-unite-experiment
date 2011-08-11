let s:save_cpo = &cpo
set cpo&vim

function! s:functions()"{{{
  redir => _
  silent verbose function
  redir END
  let output = split(_, '\n')

  let result = []
  while !empty(output)
    let [funcname, filename ] = remove(output,0,1)
    let funcname = matchstr(funcname, '\vfunction \zs.*')
    let filename = matchstr(filename, '\vLast set from \zs.*')
    call add(result, {
          \ "name": funcname,
          \ "path": filename,
          \ })
  endwhile
  return result
endfunction"}}}

let s:unite_source = { 
      \ "name": 'function',
      \ "hooks": {},
      \ "description": "function",
      \ }

function! s:unite_source.gather_candidates(args, context)"{{{
  let candidates = []
  for f in s:functions()
    call add(candidates, {
          \ "word": f.name,
          \ "abbr": f.name,
          \ "source": "function",
          \ "kind": "jump_list",
          \ "action__path": fnamemodify(f.path, ":p"),
          \ "action__pattern" : substitute(f.name, '\v\<SNR\>\d+_(.*)', '\1', ''),
          \ })
  endfor
  return candidates
endfunction"}}}

function! unite#sources#function#define()"{{{
  return s:unite_source
endfunction"}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker:
