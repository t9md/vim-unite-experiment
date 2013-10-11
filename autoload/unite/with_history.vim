" Unite_with_history:
" ==================================================================
let s:u = {
      \ "history_size": 10,
      \ "history": [],
      \ "index": 0,
      \ }

function! s:u.launch(...) "{{{
  let buffer_name = self.buffer_name()
  let cmd = "Unite " . join([self.source_name] + a:000, ":")
        \ . " -buffer-name=" . buffer_name
  execute cmd
  call add(self.history, buffer_name)
  if len(self.history) > self.history_size
    call remove(self.history, 0) 
  endif
endfunction "}}}

function! s:u.buffer_name() "{{{
  let index = self.index
  let self.index = (self.index + 1 ) % self.history_size
  return self.source_name . "_" . index
endfunction "}}}

function! s:u.resume(direction) "{{{
  if a:direction == "previous"
    let buffer_name = self.previous()
  elseif a:direction == "next"
    let buffer_name = self.next()
  endif
  let self.last_buffer_name = buffer_name
  " echo " #### " . buffer_name
  " echo " #### " . buffer_name
  if buffer_name == -1
    return
  endif
  let context = unite#get_context()
  set lazyredraw
  call unite#view#_close(context.buffer_name)
  let cmd =  "UniteResume " . buffer_name
  exe cmd
  set nolazyredraw
  redraw
endfunction "}}}

function! s:u.previous() "{{{
  let index = index(self.history, b:unite.buffer_name)
  let prev_index = index - 1
  if prev_index >= 0
    return get(self.history, prev_index, -1)
  else
    return -1
  endif
endfunction "}}}

function! s:u.next() "{{{
  let index = index(self.history, b:unite.buffer_name)
  let next_index = index + 1
  if next_index < self.history_size
    return get(self.history, next_index,-1)
  else
    return -1
  endif
endfunction "}}}

" create instance
function! s:u.new(source_name)
  let o = deepcopy(self)
  let o.source_name = a:source_name
  return o
endfunction

function! unite#with_history#new(...)
  return call(s:u.new, a:000, s:u)
endfunction

let g:ext_unite_history = {}
function! unite#with_history#setup(source_name, command_name)
  let g:ext_unite_history[a:source_name] = unite#with_history#new(a:source_name)
  let base = 'g:ext_unite_history["' . a:source_name .'"]'
  execute "command! -nargs=* -complete=dir " . a:command_name . " :call " .base.".launch(<f-args>)"
  call s:set_mapping(a:source_name, base)
endfunction

function! s:set_mapping(source_name, base)
  exe  "nnoremap <silent> <Plug>(ext-unite-with_history-" . a:source_name . "-p) :call " .a:base. ".resume('previous')<CR>"
  exe  "nnoremap <silent> <Plug>(ext-unite-with_history-" . a:source_name . "-n) :call " .a:base. ".resume('next')<CR>"
  exe  "inoremap <silent> <Plug>(ext-unite-with_history-" . a:source_name . "-p) <C-o>:call " .a:base. ".resume('previous')<CR>"
  exe  "inoremap <silent> <Plug>(ext-unite-with_history-" . a:source_name . "-n) <C-o>:call " .a:base. ".resume('next')<CR>"
endfunction
