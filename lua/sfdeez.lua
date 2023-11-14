local function auth(alias)
  if not alias or alias == '' then
    alias = vim.fn.input('Alias: ')
  end

  local job = vim.fn.jobstart('sfdx force:auth:web:login -a ' .. alias)
end

local function create_class(name)
  if not name or name == '' then
    name = vim.fn.input('Class Name: ')
  end

  local job = vim.fn.jobstart('sfdx force:apex:class:create -n ' .. name, {
    on_exit = function(_, code)
      if code == 0 then
        vim.cmd('! sfdx force:source:open -n ' .. name)
      end
    end
  })
end

local function create_trigger(name)
  if not name or name == '' then
    name = vim.fn.input('Trigger Name: ')
  end

  local job = vim.fn.jobstart('sfdx force:apex:trigger:create -n ' .. name, {
    on_exit = function(_, code)
      if code == 0 then
        vim.cmd('! sfdx force:source:open -n ' .. name)
      end
    end
  })
end

local function deploy()
  local current_file = vim.fn.expand('%:p')
  local cmd = 'sfdx force:source:deploy -p ' .. current_file
  vim.cmd('! ' .. cmd)
end

local function run_test_file()
  local current_file = vim.fn.expand('%:p')
  local cmd = 'sfdx force:apex:test:run -l RunLocalTests -r human -w 10 -c -d ' .. current_file

  vim.cmd('hsplit')

  local new_buffer = vim.fn.bufnr('%')

  local job = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      vim.api.nvim_buf_set_lines(new_buffer, 0, -1, false, vim.split(data, '\n'))
    end,
    on_exit = function(_, _)
      vim.cmd('normal! ggVGd')
    end,
  })

  vim.cmd('wincmd w')
end

local function run_test_at_cursor()
  local current_file = vim.fn.expand('%:p')
  local current_line = vim.fn.line('.')
  local cmd = 'sfdx force:apex:test:run -l RunLocalTests -r human -w 10 -c -d ' .. current_file .. ' -n ' .. current_line

  vim.cmd('hsplit')

  local new_buffer = vim.fn.bufnr('%')

  local job = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      vim.api.nvim_buf_set_lines(new_buffer, 0, -1, false, vim.split(data, '\n'))
    end,
    on_exit = function(_, _)
      vim.cmd('normal! ggVGd')
    end,
  })

  vim.cmd('wincmd w')
end

return {
  auth = auth,
  create_class = create_class,
  create_trigger = create_trigger,
  deploy = deploy
  run_test_file = run_test_file,
  run_test_at_cursor = run_test_at_cursor,
}
