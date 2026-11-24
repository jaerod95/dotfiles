local builtin = require("telescope.builtin")

-- Finds the folder of the NestJS feature module the current file belongs to: the nearest folder
-- at or above the file that has a *.module.ts, without leaving the file's package.
local find_module_folder = function(file)
  local package_root = vim.fs.root(file, "package.json") or vim.fn.getcwd()
  for folder in vim.fs.parents(file) do
    if #folder < #package_root then break end
    if vim.fn.glob(folder .. "/*.module.ts") ~= "" then return folder end
  end
  return vim.fs.dirname(file)
end

-- Lists every file in the current feature module: controller, module, services, daos, dtos, specs.
return function()
  local folder = find_module_folder(vim.api.nvim_buf_get_name(0))
  builtin.find_files({
    cwd = folder,
    prompt_title = "Module files: " .. vim.fn.fnamemodify(folder, ":~:."),
    previewer = false,
    find_command = { "rg", "--files", "--glob", "!**/{node_modules,dist}/**" },
  })
end
