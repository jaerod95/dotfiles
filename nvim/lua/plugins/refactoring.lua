local javascript_variable_log = 'console.log("%s %%s", JSON.stringify(%s))'

require("refactoring").setup({
  print_var_statements = {
    javascript = { javascript_variable_log },
    typescript = { javascript_variable_log },
    javascriptreact = { javascript_variable_log },
    typescriptreact = { javascript_variable_log },
  },
})

-- Override refactoring.nvim's debug-path builder so print_var prefixes read as
-- "(module) (scope) (scope) variable:" instead of a bare top-level "(anon)".
-- Anonymous callbacks fall back to the method they're passed to (arr.flatMap(cb)
-- -> "flatMap"), and everything is rooted at the module name.
local ts = vim.treesitter
local api = vim.api
local debug_utils = require("refactoring.debug.debug_utils")

local control_flow = {
  if_statement = "if",
  for_statement = "for",
  for_in_statement = "for_in",
  while_statement = "while",
  do_statement = "do",
  switch_statement = "switch",
}

local function_scopes = {
  arrow_function = true,
  function_declaration = true,
  function_expression = true,
  method_definition = true,
}

local function node_text(node, bufnr)
  if not node then
    return nil
  end
  local text = ts.get_node_text(node, bufnr)
  if text == nil or text == "" then
    return nil
  end
  return text
end

-- Every file here is index.js, so the parent directory is the real identifier.
local function module_name(bufnr)
  local path = api.nvim_buf_get_name(bufnr)
  if path == "" then
    return "(anon)"
  end
  local base = vim.fn.fnamemodify(path, ":t:r")
  if base == "index" or base == "" then
    return vim.fn.fnamemodify(path, ":h:t")
  end
  return base
end

-- Assigned name, else the method the function is passed to, else nil (anon).
local function scope_name(node, bufnr)
  local t = node:type()
  if t == "function_declaration" or t == "method_definition" then
    return node_text(node:field("name")[1], bufnr)
  end
  if t == "function_expression" then
    local own = node_text(node:field("name")[1], bufnr)
    if own then
      return own
    end
  end

  local parent = node:parent()
  if not parent then
    return nil
  end
  local parent_type = parent:type()

  if parent_type == "variable_declarator" then
    return node_text(parent:field("name")[1], bufnr)
  elseif parent_type == "pair" then
    return node_text(parent:field("key")[1], bufnr)
  elseif parent_type == "assignment_expression" then
    return node_text(parent:field("left")[1], bufnr)
  elseif parent_type == "arguments" then
    local call = parent:parent()
    if call and call:type() == "call_expression" then
      local fn = call:field("function")[1]
      if fn and fn:type() == "member_expression" then
        return node_text(fn:field("property")[1], bufnr)
      end
      return node_text(fn, bufnr)
    end
  end

  return nil
end

debug_utils.get_debug_path = function(refactor, point)
  local bufnr = refactor.bufnr
  local ok, node = pcall(ts.get_node, { bufnr = bufnr, pos = { point.row - 1, point.col } })

  local segments = {}
  if ok and node then
    local current = node
    while current do
      local t = current:type()
      if control_flow[t] then
        table.insert(segments, control_flow[t])
      elseif function_scopes[t] then
        table.insert(segments, scope_name(current, bufnr) or "(anon)")
      end
      current = current:parent()
    end
  end

  table.insert(segments, module_name(bufnr))

  local parts = {}
  for i = #segments, 1, -1 do
    table.insert(parts, "(" .. segments[i] .. ")")
  end
  return table.concat(parts, " ")
end
