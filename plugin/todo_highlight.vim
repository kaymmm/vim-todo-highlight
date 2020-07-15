" File: todo_highlight.vim
" Author: Saksham Gupta <https://github.com/sakshamgupta05>
" Description: a Vim/Neovim plugin to highlight todos and fixmes

" make sure file is loaded only once
if exists('g:loaded_todo_highlight')
  finish
endif

" default highlight settings
if !exists('g:todo_highlight_defaults')
  let g:todo_highlight_defaults = {
      \   'gui_fg_color': '#ffffff',
      \   'gui_bg_color': '#ffbd2a',
      \   'cterm_fg_color': 'white',
      \   'cterm_bg_color': '214',
      \   'only_comments': 1
      \ }
endif

" default highlight config
if !exists('g:todo_highlight_config')
  let g:todo_highlight_config = {
      \   'TODO:': {
      \     'gui_fg_color': '#ffffff',
      \     'gui_bg_color': '#ffbd2a',
      \     'cterm_fg_color': 'white',
      \     'cterm_bg_color': '214',
      \     'only_comments': 1
      \   },
      \     'FIXME:': {
      \     'gui_fg_color': '#ffffff',
      \     'gui_bg_color': '#f06292',
      \     'cterm_fg_color': 'white',
      \     'cterm_bg_color': '204',
      \     'only_comments': 1
      \   }
      \ }
endif

let s:find_in_comments = ' containedin=.*Comment.*'

" creates annotation group and highlight it according to the config
function! s:CreateAnnotationGroup(annotation, config, dummy)
  " set group name -> my_annotation
  let l:group_name = 'todo_highlight_' . a:dummy
  let l:only_comments = get(a:config, 'only_comments',
        \ g:todo_highlight_defaults['only_comments']) ? s:find_in_comments : ''

  " make group for annotation where its pattern matches and is inside comment
  execute 'augroup ' . l:group_name
    autocmd!
    execute 'autocmd Syntax * syntax match ' . l:group_name .
          \ ' /\v' . a:annotation . '/' . l:only_comments
  augroup END

  " highlight the group according to the config
  if has('termguicolors')
    execute 'hi ' l:group_name .
          \ ' guifg = ' . get(a:config, 'gui_fg_color',
          \     g:todo_highlight_defaults['gui_fg_color']) .
          \ ' guibg = ' . get(a:config, 'gui_bg_color',
          \     g:todo_highlight_defaults['gui_bg_color'])
  else
    execute 'hi ' l:group_name .
          \ ' ctermfg = ' . get(a:config, 'cterm_fg_color',
          \     g:todo_highlight_defaults['cterm_fg_color']) .
          \ ' ctermbg = ' . get(a:config, 'cterm_bg_color',
          \     g:todo_highlight_defaults['cterm_bg_color'])
  endif
endfunction

" highlights the default annotation groups (`TODO:`, `FIXME:`)
let s:itr = 0
for [annotation, config] in items(g:todo_highlight_config)
  call s:CreateAnnotationGroup(annotation, config, s:itr)
  let s:itr += 1
endfor

let g:loaded_todo_highlight = 1
