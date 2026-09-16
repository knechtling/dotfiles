local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.ignorecase = true
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 5
opt.undofile = true
opt.updatetime = 250
opt.completeopt = { "menu", "menuone", "noselect" }
opt.clipboard = "unnamedplus"
opt.grepprg = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  severity_sort = true,
  update_in_insert = false,
  float = { border = "rounded", source = true },
})

local group = vim.api.nvim_create_augroup("NativeEditing", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function() vim.hl.on_yank() end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en", "de" }
    for _, key in ipairs({ "j", "k" }) do
      vim.keymap.set({ "n", "x" }, key, function()
        return vim.v.count == 0 and "g" .. key or key
      end, { buffer = true, expr = true, desc = "Move by display line" })
    end
    vim.keymap.set("n", "<leader>us", function()
      vim.opt_local.spell = not vim.opt_local.spell:get()
    end, { buffer = true, desc = "Toggle spelling (German / English)" })
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})
