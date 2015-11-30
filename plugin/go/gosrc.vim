" gosrc.vim - Open golang source file with completion.
"
" Commands:
"   :Gosrc {file_name}
"       Open (:split) golang source file which is at $GOROOT or $GOPATH.
"
" Version: 1.0
" Author:  MURAOKA Taro <koron.kaoriya@gmail.com>
" License: VIM LICENSE

command! -nargs=1 -complete=customlist,s:complSrc Gosrc :call s:Gosrc(<f-args>)

function! s:Gosrc(name)
  let path = s:findSrc(a:name)
  if path == '' || !filereadable(path)
    echohl WarningMsg
    echomsg 'No source found for "' . a:name . '"'
    echohl None
    return
  end
  execute 'split ' . path
endfunction

function! s:findSrc(name)
  let dirs = s:getDirs()
  let files = globpath(join(dirs, ','), 'src/' . a:name, 0, 1)
  if len(files) == 0
    return ''
  endif
  return files[0]
endfunction

function! s:complSrc(lead, line, pos)
  let cands = []
  let query = a:lead . '*'
  let dirs = s:getDirs()
  for dir in dirs
    let root = dir . '/src'
    for path in globpath(root, query, 1, 1)
      let entry = substitute(path[len(root)+1:], '[\\]', '/', 'g')
      if isdirectory(path)
        let cands += [entry . '/']
      elseif path =~ '\.go$'
        let cands += [entry]
      endif
    endfor
  endfor
  return cands
endfunction

function! s:getDirs()
  let dirs = []
  " GOROOT
  if exists('$GOROOT')
    let goroot = $GOROOT
  elseif executable('go')
    let goroot = substitute(system('go env GOROOT'), '\n', '', 'g')
    if v:shell_error
      echohl WarningMsg
      echomsg '"go env GOROOT" failed'
      echohl None
    endif
  endif
  if len(goroot) != 0 && isdirectory(goroot)
    let dirs += [goroot]
  endif
  " GOPATH
  let sep = ':'
  if has('win32') || has('win64')
    let sep = ';'
  endif
  let workspaces = split($GOPATH, sep)
  if len(workspaces) > 0
    let dirs += workspaces
  endif
  return dirs
endfunction

" vim:set ts=8 sts=2 sw=2 tw=0 et:
