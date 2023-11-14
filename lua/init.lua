local M = {}

function M.auth(alias)
  local job = vim.fn.jobstart('sfdx force:auth:web:login -a ' .. alias, {})
end

vim.cmd(
  "command! -nargs=1 SFDXAuth lua auth(<args>)"
)

function M.sfdx_create_class(name)
  local job = vim.fn.jobstart('sfdx force:apex:class:create -n ' .. name, {
    on_exit = function(_, code)
      if code == 0 then
        vim.cmd('! sfdx force:source:open -n ' .. name)
      end
    end
  })
end

vim.cmd(
  "command! -nargs=1 SFDXCreateClass lua sfdx_create_class(<args>)"
)

function M.sfdx_create_trigger(name)
  local job = vim.fn.jobstart('sfdx force:apex:trigger:create -n ' .. name, {
    on_exit = function(_, code)
      if code == 0 then
        vim.cmd('! sfdx force:source:open -n ' .. name)
      end
    end
  })
end

vim.cmd(
  "command! -nargs=1 SFDXCreateTrigger lua sfdx_create_trigger(<args>)"
)

function M.deploy()
  local current_file = vim.fn.expand('%:p')
  local cmd = 'sfdx force:source:deploy -p ' .. current_file
  vim.cmd('! ' .. cmd)
end

return M
