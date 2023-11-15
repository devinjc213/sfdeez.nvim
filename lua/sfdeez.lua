local function buf_handler(cmd)
  vim.cmd('below split | enew')
  vim.cmd('resize 10')

  local message_buffer = vim.fn.bufnr('%')

  vim.api.nvim_buf_set_option(message_buffer, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(message_buffer, 'swapfile', false)
  vim.api.nvim_buf_set_option(message_buffer, 'bufhidden', 'wipe')

  local job = vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(message_buffer, -1, -1, false, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(message_buffer, -1, -1, false, data)
      end
    end, 
  })
end

local function auth(alias)
  if not alias or alias == '' then
    alias = vim.fn.input('Alias: ')
  end

  local cmd = 'sfdx force:auth:web:login -a ' .. alias

  buf_handler(cmd)
end

local function create_class(name)
  if not name or name == '' then
    name = vim.fn.input('Class Name: ')
  end

  local cmd = 'sfdx force:apex:class:create -n ' .. name

  buf_handler(cmd)
end

local function create_trigger(name)
  if not name or name == '' then
    name = vim.fn.input('Trigger Name: ')
  end
  
  local cmd = 'sfdx force:apex:trigger:create -n ' .. name

  buf_handler(cmd)
end

local function deploy_file()
  local current_file = vim.fn.expand('%:p')
  local cmd = 'sfdx force:source:deploy -p ' .. current_file

  buf_handler(cmd)
end

local function run_test_file()
  local current_file = vim.fn.expand('%:p')
  local cmd = '! sfdx force:apex:test:run -l RunLocalTests -r human -w 10 -c -d ' .. current_file

  buf_handler(cmd)
end

local function run_test_at_cursor()
  local current_file = vim.fn.expand('%:p')
  local current_line = vim.fn.line('.')
  local cmd = 'sfdx force:apex:test:run -l RunLocalTests -r human -w 10 -c -d ' .. current_file .. ' -n ' .. current_line

  buf_handler(cmd)
end

return {
  auth = auth,
  create_class = create_class,
  create_trigger = create_trigger,
  deploy_file = deploy_file,
  run_test_file = run_test_file,
  run_test_at_cursor = run_test_at_cursor,
}
