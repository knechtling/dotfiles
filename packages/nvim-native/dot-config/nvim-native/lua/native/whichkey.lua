local wk = require("which-key")
wk.setup({
  preset = "modern",
  delay = 250,
  icons = { mappings = false },
})
wk.add({
  { "<leader>f", group = "Files / buffers" },
  { "<leader>b", group = "Buffers" },
  { "<leader>g", group = "Git" },
  { "<leader>s", group = "Search" },
  { "<leader>c", group = "Code / LSP" },
  { "<leader>u", group = "Toggles" },
  { "<leader>x", group = "Diagnostics" },
  { "<leader>w", group = "Wiki", mode = { "n", "x" } },
  { "<leader>wg", group = "Wiki graph" },
  { "<leader>wl", group = "Wiki links" },
  { "<leader>wT", group = "Wiki tags" },
  { "<leader>ww", desc = "Wiki index" },
  { "<leader>w<leader>w", desc = "Wiki journal" },
  { "<leader>wn", desc = "Open wiki page" },
})
vim.keymap.set("n", "<leader>?", function()
  wk.show({ global = false })
end, { desc = "Buffer-local keymaps" })
