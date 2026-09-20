-- Configure wiki.vim before its plugin scripts load.
vim.g.wiki_root = vim.fn.expand("~/vimwiki/text/")
-- Reserve wf/ws for wiki-wide search; keep all wiki functionality reachable.
vim.g.wiki_mappings_local = {
  ["<plug>(wiki-link-transform)"] = "<leader>wF",
  ["<plug>(wiki-tag-list)"] = "<leader>wTl",
  ["<plug>(wiki-tag-reload)"] = "<leader>wTr",
  ["<plug>(wiki-tag-rename)"] = "<leader>wTn",
  ["<plug>(wiki-tag-search)"] = "<leader>wTs",
  ["<plug>(wiki-toc-generate-local)"] = "<leader>wO",
}

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/nvim-mini/mini.pick",
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/lervag/wiki.vim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/b0o/SchemaStore.nvim",
}, { confirm = false })

require("mini.pick").setup()
require("gitsigns").setup({
  on_attach = function(buffer)
    local gs = require("gitsigns")
    local function map(key, action, desc)
      vim.keymap.set("n", key, action, { buffer = buffer, desc = desc })
    end
    map("]c", function() gs.nav_hunk("next") end, "Next Git change")
    map("[c", function() gs.nav_hunk("prev") end, "Previous Git change")
    map("<leader>gp", gs.preview_hunk, "Preview Git change")
    map("<leader>gs", gs.stage_hunk, "Stage Git change")
    map("<leader>gb", gs.blame_line, "Git blame line")
  end,
})
vim.cmd.colorscheme("tokyonight-night")

-- Prefer PATH tools; reuse existing Mason executables when available.
-- This only exposes tools, never loads or changes the LazyVim configuration.
local mason_bin = (vim.env.XDG_DATA_HOME or (vim.env.HOME .. "/.local/share")) .. "/nvim/mason/bin"
if vim.fn.isdirectory(mason_bin) == 1 then
  vim.env.PATH = vim.env.PATH .. ":" .. mason_bin
end

require("conform").setup({
  formatters_by_ft = {
    markdown = { "prettier" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    yaml = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    python = { "ruff_format" },
  },
  -- Formatting is explicit by default; preserve project formatting files.
})

vim.api.nvim_create_user_command("NativeUpdate", function() vim.pack.update() end, {
  desc = "Review native plugin updates",
})
