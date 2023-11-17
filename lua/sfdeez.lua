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

  local cmd = '! sf org login web --alias ' .. alias .. ' --instance-url https://test.salesforce.com --set-default'

  buf_handler(cmd)
end

local function logout()
  local cmd = '! sf org logout --all --no-prompt'

  buf_handler(cmd)
end

local function create_class(name)
  if not name or name == '' then
    name = vim.fn.input('Class Name: ')
  end

  local cmd = '! sf apex generate class --name ' .. name

  buf_handler(cmd)
end

local function create_trigger(name)
if not name or name == '' then
    name = vim.fn.input('Trigger Name: ')
  end

  local cmd = '! sf apex generate trigger --name ' .. name

  buf_handler(cmd)
end

local function deploy_file()
  local current_file = vim.fn.expand('%:t:r')

  local cmd = '! sf project deploy start --metadata ' .. current_file

  buf_handler(cmd)
end

local function run_test_file()
  local current_file = vim.fn.expand('%:t:r')
  local cmd = '! sf apex run test --class-names ' .. current_file .. ' --result-format human --synchronous'

  buf_handler(cmd)
end
 
local function run_test_at_cursor()
  local current_file = vim.fn.expand('%:t:r')
  local current_line = vim.fn.line('.')
  local current_buf = vim.fn.bufnr('%')

  local is_test_line = current_line
  while is_test_line > 0 do
    local line_content = vim.api.nvim_buf_get_lines(current_buf, is_test_line - 1, is_test_line, false)[1]
    if line_content:find('@isTest') then
      break
    end
    is_test_line = is_test_line - 1
  end

  if is_test_line == 0 then
    print('No test found.  Please make sure cursor is at or below @isTest annotation.')
    return
  end

  local test_line = vim.api.nvim_buf_get_lines(current_buf, is_test_line, is_test_line + 1, false)[1]
  local test_name = test_line:match('(%a[%w_]*%s*)%b()')

  local cmd = '! sf apex run test --tests ' .. current_file .. '.' .. test_name .. ' --result-format human --synchronous' 

  buf_handler(cmd)
end

return {
  auth = auth,
  logout = logout,
  create_class = create_class,
  create_trigger = create_trigger,
  deploy_file = deploy_file,
  run_test_file = run_test_file,
  run_test_at_cursor = run_test_at_cursor,
}
