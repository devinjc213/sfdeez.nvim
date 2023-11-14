local function auth(alias)
  local job = vim.fn.jobstart('sfdx force:auth:web:login -a ' .. alias)
end

local function create_class(name)
  local job = vim.fn.jobstart('sfdx force:apex:class:create -n ' .. name, {
    on_exit = function(_, code)
      if code == 0 then
        vim.cmd('! sfdx force:source:open -n ' .. name)
      end
    end
  })
end

local function create_trigger(name)
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

return {
  auth = auth,
  create_class = create_class,
  create_trigger = create_trigger,
  deploy = deploy
}
