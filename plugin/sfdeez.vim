if exists('g:loaded_sfdeez') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! SFDXAuth lua require'sfdeez'.auth(<f-args>)
command! SFDXCreateClass lua require'sfdeez'.create_class(<f-args>)
command! SFDXCreateTrigger lua require'sfdeez'.create_trigger(<f-args>)
command! SFDXRunTestFile lua require'sfdeez'.run_test_file()
command! SFDXRunTestAtCursor lua require 'sfdeez'.run_test_at_cursor()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_sfdeez = 1
