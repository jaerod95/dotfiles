-- Like go-to-definition, but skips past .d.ts files to the implementation, which is what you
-- want for most packages in node_modules. Falls back to regular definition for non-TS servers.
local commands = {
  ts_ls = "_typescript.goToSourceDefinition",
  vtsls = "typescript.goToSourceDefinition",
}

return function()
  local bufnr = vim.api.nvim_get_current_buf()
  local client = vim.iter(vim.lsp.get_clients({ bufnr = bufnr })):find(function(c) return commands[c.name] end)
  if not client then return vim.lsp.buf.definition() end

  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  local from = { bufnr, vim.fn.line("."), vim.fn.col("."), 0 }
  local tagname = vim.fn.expand("<cword>")

  client:request("workspace/executeCommand", {
    command = commands[client.name],
    arguments = { params.textDocument.uri, params.position },
  }, function(err, result)
    if err then return vim.notify(err.message, vim.log.levels.ERROR) end
    if not result or vim.tbl_isempty(result) then
      return vim.notify("No source definition found", vim.log.levels.INFO)
    end

    -- push the tag stack like a normal definition jump so <C-t> comes back here
    vim.fn.settagstack(vim.fn.win_getid(), { items = { { tagname = tagname, from = from } } }, "t")
    if #result == 1 then
      vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
    else
      local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)
      vim.fn.setqflist({}, " ", { title = "Source definitions", items = items })
      vim.cmd("botright copen")
    end
  end, bufnr)
end
