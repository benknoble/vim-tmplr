if exists('g:loaded_tmplr')
  finish
endif
let g:loaded_tmplr = 1

let g:tmplr = get(g:, 'tmplr', 'tmplr')
let g:temples = get(g:, 'temples', 'temples')

command -nargs=? -complete=dir Temples exec tmplr#temples(<q-args>)
command -nargs=+ Etemple exec tmplr#temple_edit('edit', <f-args>)
command -nargs=+ Stemple exec tmplr#temple_edit('<mods> split', <f-args>)
command -nargs=+ Vtemple vertical Stemple <args>
command -nargs=+ Ttemple tab Stemple <args>
command -nargs=+ Etmplr exec tmplr#tmplr('edit', <f-args>)
command -nargs=+ Stmplr exec tmplr#tmplr('<mods> split', <f-args>)
command -nargs=+ Vtmplr vertical Stmplr <args>
command -nargs=+ Ttmplr tab Stmplr <args>
