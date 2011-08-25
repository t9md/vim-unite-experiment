" Unite_with_history: {{{1
" ==================================================================
let s:unite_file_with_history = {
      \ "history_size": 5,
      \ "history": [],
      \ "index": 0,
      \ }

function! s:unite_file_with_history.launch(...)
  execute "Unite " . join([self.source] + a:000, ":") . " -buffer-name=" . self.next_buffer_name()
endfunction

function! s:unite_file_with_history.next_buffer_name()
  let index = self.index
  let self.index += 1
  if self.index >= self.history_size
    let self.index = 0
  endif
  let buffer_name = self.source . "_" . index
  if len(self.history) == self.history_size
    call remove(self.history,0)
  endif
  call add(self.history, buffer_name)
  return buffer_name
endfunction

function! s:unite_file_with_history.resume(direction)
  if a:direction == "previous"
    let buffer_name = self.previous()
  elseif a:direction == "next"
    let buffer_name = self.next()
  endif
  if buffer_name == -1
    return
  endif
  execute "Unite resume -toggle -input=" . buffer_name . " -immediately"
endfunction

function! s:unite_file_with_history.previous()
  let index = index(self.history, b:unite.buffer_name)
  let index -= 1
  if index == -1
    return -1
  endif
  return get(self.history, index)
endfunction

function! s:unite_file_with_history.next()
  let index = index(self.history, b:unite.buffer_name)
  let index += 1
  if index == len(self.history)
    return -1
  endif
  return get(self.history, index)
endfunction

" create instance
function! s:unite_file_with_history.new(source, substitute_func)
  let o = deepcopy(self)
  let o.source = a:source
  for idx in range(self.history_size)
    call call(a:substitute_func, [a:source . "_" . idx])
  endfor
  return o
endfunction

function! unite#file_with_history#new(...)
  return call(s:unite_file_with_history.new, a:000, s:unite_file_with_history)
endfunction
