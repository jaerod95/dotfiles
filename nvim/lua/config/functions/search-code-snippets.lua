local actions = require("telescope.actions")
local config = require("telescope.config")
local finders = require("telescope.finders")
local luasnip = require("luasnip")
local pickers = require("telescope.pickers")
local state = require("telescope.actions.state")

return function()
  local snippets = luasnip.available()[vim.bo.filetype] or {}
  pickers
    .new({}, {
      finder = finders.new_table({
        results = snippets,
        entry_maker = function(snippet)
          local description = snippet.description and " - " .. snippet.description[1] or ""
          return {
            value = snippet,
            display = snippet.trigger .. " - " .. snippet.name .. description,
            ordinal = snippet.trigger .. " " .. snippet.name,
          }
        end,
      }),
      sorter = config.values.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = state.get_selected_entry()
          if selection and selection.value then
            vim.api.nvim_input("i" .. selection.value.trigger)
            vim.schedule(function() luasnip.expand() end)
          end
        end)
        return true
      end,
    })
    :find()
end
