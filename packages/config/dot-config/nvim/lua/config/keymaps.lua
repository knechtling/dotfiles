-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>fx", ":!chmod +x %<CR>", {
  desc = "Mark current file as executable.",
  silent = true,
  noremap = true,
})

vim.cmd([[cnoreabbrev w!! w !sudo tee % >/dev/null <Bar> edit!]])

-- ── QWERTZ ergonomics ──────────────────────────────────────────────
-- ö ä Ö Ä sit on the home row where QWERTY has ; ' — use them as the
-- bracket keys, so [d ]d [b ]b ci[ ya{ … need no AltGr gymnastics.
for lhs, rhs in pairs({ ["ö"] = "[", ["ä"] = "]", ["Ö"] = "{", ["Ä"] = "}" }) do
  vim.keymap.set({ "n", "x", "o" }, lhs, rhs, { remap = true, desc = "QWERTZ " .. rhs })
end

-- Pipe without AltGr (markdown tables, shell pipelines).
vim.keymap.set({ "i", "c" }, "<M-p>", "|", { desc = "Insert |" })
