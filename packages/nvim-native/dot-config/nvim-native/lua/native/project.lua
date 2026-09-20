local M = {}
function M.root()
  local file = vim.api.nvim_buf_get_name(0)
  local start = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
  local wiki = vim.fs.normalize(vim.g.wiki_root):gsub("/$", "")
  if start == wiki or start:sub(1, #wiki + 1) == wiki .. "/" then return wiki end
  return vim.fs.root(start, { ".git", "pyproject.toml", "package.json", "Makefile", ".marksman.toml" }) or start
end
vim.api.nvim_create_user_command("NativeProject", function()
  local lines = { "Search root: " .. M.root(), "Activated environment: " .. (vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX or "none") }
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    lines[#lines + 1] = client.name .. ": " .. (client.config.root_dir or "single file")
    if client.name == "pyright" then
      local python = (client.config.settings or {}).python or {}
      lines[#lines + 1] = "Pyright interpreter: " .. (python.pythonPath or "server/project discovery")
    end
  end
  vim.notify(table.concat(lines, "\n"))
end, { desc = "Show project roots and Python environment" })
return M
