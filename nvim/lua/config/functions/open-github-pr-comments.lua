local filter = require("lib.tables.filter")
local get = require("lib.tables.get")
local json = require("lib.json")
local map = require("lib.tables.map")

return function()
  local file = io.open("/tmp/github-pr-comments.json")
  if not file then return print("Failed to parse github comments, run review <pr number>") end

  local content = file:read("*all")
  file:close()

  local success, comments = pcall(json.parse, content)
  if not success then return print("Failed to parse github comments") end

  local threads = filter(
    get(comments, { "data", "repository", "pullRequest", "reviewThreads", "nodes" }, {}),
    function(thread) return not thread.isResolved end
  )
  if #threads == 0 then return print("There are no unresolved inline comments on this PR") end

  local qf_items = {}

  for _, thread in ipairs(threads) do
    local filename = thread.comments.nodes[1].path
    local file_exists = filename and vim.fn.filereadable(thread.comments.nodes[1].path) == 1
    local line_number = thread.comments.nodes[1].originalLine or thread.comments.nodes[1].line
    local formatted_comments = map(
      thread.comments.nodes,
      function(comment) return "@" .. comment.author.login .. ": " .. comment.body end
    )

    if file_exists and line_number then
      table.insert(qf_items, {
        filename = filename,
        lnum = line_number,
        text = table.concat(formatted_comments, "\n"),
        user_data = {
          thread_id = thread.id,
          comment_id = thread.comments.nodes[1].databaseId,
        },
      })
    end
  end

  vim.fn.setqflist(qf_items)
  vim.cmd(":copen")
  vim.cmd("set wrap! linebreak!")
end
