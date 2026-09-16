if vim.fn.has("nvim-0.12") == 0 then
  error("nvim-native requires Neovim 0.12 or newer")
end

vim.g.mapleader = " "
vim.g.maplocalleader = ","
require("native.options")
require("native.plugins")
require("native.lsp")
require("native.keymaps")
require("native.whichkey")
