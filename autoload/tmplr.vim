function s:error_msg(message)
  return 'tmplr.vim: '.a:message
endfunction

function s:error(message)
    return printf('echomsg "%s"', escape(s:error_msg(a:message), '"'))
endfunction

function tmplr#temples(dir) abort
  let l:args = ' --print-dir'
  if len(a:dir)
    let l:args .= ' --dir '.a:dir
  endif
  let l:dir = trim(system(g:temples.l:args))
  if v:shell_error
    return s:error('error in '.g:temples.': '.l:dir)
  endif
  return 'edit '.l:dir
endfunction

function tmplr#temple_edit(cmd, ...) abort
  let l:args = ' --print-temple'
  let [l:dir_arg, l:temple_arg] = ['', '']
  for l:arg in a:000
    if isdirectory(l:arg)
      let l:dir_arg = ' --dir '.l:arg
    else
      let l:temple_arg = ' --temple '.l:arg
    endif
  endfor
  if !len(l:temple_arg)
    return s:error('TempleEdit requires a temple')
  endif
  let l:args .= l:dir_arg.' '.l:temple_arg
  let l:temple = trim(system(g:temples.l:args))
  if v:shell_error
    return s:error('error in '.g:temples.': '.l:temple)
  endif
  return a:cmd.' '.l:temple
endfunction

function tmplr#tmplr(cmd, ...) abort
  let l:args = [' --no-edit']
  let l:i = 0
  while l:i < a:0
    if a:000[l:i] =~# '-d\|--dir'
      let l:i += 1
      call add(l:args, '--dir '.a:000[l:i])
    elseif a:000[l:i] =~#
          \ '--stdout\|--no-edit\|-h\|--help\|--version\|-F\|--print-file'
      " no op
    else
      call add(l:args, a:000[l:i])
    endif
    let l:i += 1
  endwhile
  let l:tmplr_args = join(l:args, ' ')
  let l:rendered = systemlist(g:tmplr.l:tmplr_args)
  if v:shell_error
    return s:error('error in '.g:tmplr.': '.join(l:rendered, "\n"))
  endif
  if len(l:rendered) > 1
    return s:error('temple rendered on stdout, unable to edit! Use -f')
  endif
  return a:cmd.' '.l:rendered[0]
endfunction
