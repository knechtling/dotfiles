-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>fx", ":!chmod +x %<CR>", {
  desc = "Mark current file as executable.",
  silent = true,
  noremap = true,
})
vim.cmd("cnoreabbrev w!! w !sudo tee % >/dev/null | edit!")
