if exists('g:loaded_sfdeez') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* SFDeezAuth lua require'sfdeez'.auth(<f-args>)
command! SFDeezLogout lua require'sfdeez'.logout()
command! -nargs=* SFDeezCreateClass lua require'sfdeez'.create_class(<f-args>)
command! -nargs=* SFDeezCreateTrigger lua require'sfdeez'.create_trigger(<f-args>)
command! SFDeezDeployFile lua require'sfdeez'.deploy_file()
command! SFDeezRunTestFile lua require'sfdeez'.run_test_file()
command! SFDeezRunTestAtCursor lua require 'sfdeez'.run_test_at_cursor()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_sfdeez = 1
