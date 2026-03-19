local actions = require("telescope.actions")
local state = require("telescope.actions.state")
local telescope = require("telescope.builtin")

local directory = os.getenv("HOME") .. "/.local/share/db_ui/"

return function()
  telescope.find_files({
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = state.get_selected_entry()
        if selection and selection[1] then
          local file_path = directory .. selection.value
          local file = io.open(file_path, "r")
          if file then
            local lines = {}
            for line in file:lines() do
              table.insert(lines, line)
            end
            file:close()

            vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
          end
        end
      end)
      return true
    end,
    cwd = directory,
    no_ignore = true,
    previewer = false,
  })
end
