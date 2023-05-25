-- This plugin is a wrapper for markmap-cli
local uv = vim.loop
local cmd = vim.api.nvim_create_user_command
local M = {}

M.setup = function(ctx)
  -- Setup options
  html_output = ctx.html_output
  hide_toolbar = ctx.hide_toolbar

  -- bool conditions
  if html_output == nil then
    html_output = " -o /tmp/markmap.html " -- by defaullt create the html file here
  else
    html_output = " -o " .. html_output
  end

  if hide_toolbar == true then
    hide_toolbar = " --no-toolbar "
  else
    hide_toolbar = ""
  end

  -- Setup autocmds
  cmd(
    "MarkmapOpen",
    function()
      os.execute(
        "markmap " .. html_output .. hide_toolbar .. vim.fn.expand "%:p"
      )
    end,
    { desc = "Show a mental map of the current file" }
  )

  cmd(
    "MarkmapSave",
    function()
      os.execute(
        "markmap " .. html_output .. " --no-open " .. vim.fn.expand "%:p"
      )
    end,
    { desc = "Save the HTML file without opening the mindmap" }
  )
end

cmd("MarkmapWatch", function()
  local run_command = "markmap "
      .. html_output
      .. hide_toolbar
      .. " --watch "
      .. vim.fn.expand "%:p"
  print ""
  handle = uv.spawn(run_command, {
    stdio = { nil, nil, nil },
    detached = true,
  }, function(_, _, _) print "Comando ejecutado de forma asíncrona" end)
end, { desc = "Show a mental map of the current file and watch for changes" })

return M
