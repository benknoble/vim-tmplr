if exists('g:loaded_tmplr')
  finish
endif
let g:loaded_tmplr = 1

function s:log(...) abort
  for l:arg in a:000
    echomsg 'tmplr.vim: '.l:arg
  endfor
endfunction

function s:error(...) abort
  echohl ErrorMsg
  call call('s:log', a:000)
  echohl None
endfunction

let g:tmplr = get(g:, 'tmplr', 'tmplr')
let g:temples = get(g:, 'temples', 'temples')

if ! (executable(g:tmplr) && executable(g:temples))
  call s:error(
        \ 'tmplr or temples program not executable',
        \ 'tmplr executable: '.g:tmplr,
        \ 'temples executable: '.g:temples,
        \ )
  finish
endif

function s:version() abort
  let l:pieces = split(trim(system(g:tmplr.' --version')), '\.')
  return map(l:pieces, {_,p -> str2nr(p)})
endfunction

let [s:major, s:minor, s:patch] = s:version()
if !( s:major > 0 || s:minor >= 2 )
  call s:error(
        \ 'requires tmplr >= 0.2.0',
        \ printf('current: tmplr == %d.%d.%d', s:major, s:minor, s:patch),
        \ )
  finish
endif

command -nargs=? -complete=dir Temples exec tmplr#temples(<q-args>)
command -nargs=+ Etemple exec tmplr#temple_edit('edit', <f-args>)
command -nargs=+ Stemple exec tmplr#temple_edit('split', <f-args>)
command -nargs=+ Vtemple exec tmplr#temple_edit('vsplit', <f-args>)
command -nargs=+ Ttemple exec tmplr#temple_edit('tabedit', <f-args>)
