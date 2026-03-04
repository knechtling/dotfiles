-- Keep Neovim logs in XDG state, never inside config.
vim.env.NVIM_LOG_FILE = vim.fn.stdpath("state") .. "/log"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
