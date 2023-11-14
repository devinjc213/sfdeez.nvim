if exists('g:loaded_sfdeez') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=1 SFDXAuth lua require'sfdeez'.auth(<f-args>)
command! -nargs=1 SFDXCreateClass lua require'sfdeez'.create_class(<f-args>)
command! -nargs=1 SFDXCreateTrigger lua require'sfdeez'.create_trigger(<f-args>)
command! -nargs=0 SFDXRunTestFile lua require'sfdeez'.run_test_file()
command! -nargs=0 SFDXRunTestAtCursor lua require 'sfdeez'.run_test_at_cursor()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_sfdeez = 1
