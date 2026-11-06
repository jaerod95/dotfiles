local actions = require("telescope.actions")
local conf = require("telescope.config")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local state = require("telescope.actions.state")
local to_camel_case = require("lib.strings.to-camel-case")

local repo = vim.fn.expand("~/Documents/work/api-gateway")
local apps = repo .. "/src/apps"

local function get_endpoints()
  local endpoints = {}

  local graphql_endpoints = vim.fn.systemlist({
    "rg",
    "-l",
    [==[^\s*resolve:]==],
    "-g",
    "**/graphql/query/**/index.js",
    "-g",
    "**/graphql/mutation/**/index.js",
    apps,
  })

  for _, path in ipairs(graphql_endpoints) do
    local operation = path:match("([^/]+)/index%.js$")
    table.insert(endpoints, {
      app = path:match("/apps/([^/]+)/"),
      type = path:match("/graphql/(query)/") or path:match("/graphql/(mutation)/"),
      name = to_camel_case(operation),
      path = path,
    })
  end

  local rpc_endpoints = vim.fn.systemlist({
    "rg",
    "--no-heading",
    "--with-filename",
    "--no-line-number",
    "-o",
    "-r",
    "$1",
    [==[^\tname:\s*["']([^"']+)["']]==],
    "-g",
    "**/executables/**/index.js",
    apps,
  })

  for _, line in ipairs(rpc_endpoints) do
    local path, name = line:match("^(/.-):(.+)$")
    if path and name then
      table.insert(endpoints, {
        app = path:match("/apps/([^/]+)/"),
        type = "rpc",
        name = name,
        path = path,
      })
    end
  end

  table.sort(endpoints, function(a, b)
    if a.app ~= b.app then return a.app < b.app end
    if a.type ~= b.type then return a.type < b.type end
    return a.name < b.name
  end)

  return endpoints
end

return function()
  pickers
    .new({}, {
      finder = finders.new_table({
        results = get_endpoints(),
        entry_maker = function(endpoint)
          local display = string.format("[%s] [%s] %s", endpoint.app, endpoint.type, endpoint.name)
          return { value = endpoint, display = display, ordinal = display, path = endpoint.path }
        end,
      }),
      sorter = conf.values.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = state.get_selected_entry()
          if selection and selection.value then vim.cmd("edit " .. vim.fn.fnameescape(selection.value.path)) end
        end)
        return true
      end,
    })
    :find()
end
