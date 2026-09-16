local servers = {
  bashls = "bash-language-server",
  marksman = "marksman",
  yamlls = "yaml-language-server",
  jsonls = "vscode-json-language-server",
  pyright = "pyright-langserver",
  ruff = "ruff",
}

vim.lsp.config("pyright", {
  before_init = function(_, config)
    local root = config.root_dir or vim.fn.getcwd()
    local environment = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
    local python = environment and (environment .. "/bin/python") or (root .. "/.venv/bin/python")
    if vim.fn.executable(python) == 1 then
      config.settings = vim.tbl_deep_extend("force", config.settings or {}, { python = { pythonPath = python } })
    end
  end,
  settings = {
    pyright = { disableOrganizeImports = true },
    python = { analysis = { typeCheckingMode = "basic" } },
  },
})
vim.lsp.config("yamlls", {
  settings = { yaml = {
    keyOrdering = false,
    schemaStore = { enable = false, url = "" },
    schemas = require("schemastore").yaml.schemas(),
  } },
})
vim.lsp.config("jsonls", {
  settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
})

for server, executable in pairs(servers) do
  if vim.fn.executable(executable) == 1 then vim.lsp.enable(server) end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("NativeLsp", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then return end
    if client.name == "ruff" then client.server_capabilities.hoverProvider = false end
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    end
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "Definition" })
  end,
})

vim.api.nvim_create_user_command("NativeTools", function()
  local lines = {}
  local commands = vim.tbl_values(servers)
  vim.list_extend(commands, { "prettier", "shfmt", "shellcheck", "rg", "git" })
  table.sort(commands)
  for _, command in ipairs(commands) do
    local path = vim.fn.exepath(command)
    lines[#lines + 1] = command .. ": " .. (path ~= "" and path or "MISSING")
  end
  vim.notify(table.concat(lines, "\n"))
end, { desc = "Show language tools and their executable paths" })
