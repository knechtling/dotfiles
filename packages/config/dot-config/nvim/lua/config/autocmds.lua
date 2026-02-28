-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Set filetype for .Xresources and .Xdefaults files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { ".Xresources", ".Xdefaults", "xresources", "xdefaults" },
  desc = "Set filetype for Xresources/Xdefaults",
  callback = function()
    vim.bo.filetype = "xdefaults"
  end,
})

-- Automatically rebuild suckless-style projects when config.h is saved
local local_src_pattern = vim.fn.expand("~") .. "/.local/src/**/config.h"
local local_src_group = vim.api.nvim_create_augroup("AutoBuildLocalSrcConfig", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = local_src_group,
  pattern = local_src_pattern,
  desc = "Run make clean install after editing config.h under ~/.local/src",
  callback = function(args)
    local dir = vim.fn.fnamemodify(args.file, ":h")
    local cmd = { "sudo", "make", "-C", dir, "clean", "install" }

    local job = vim.fn.jobstart(cmd, {
      stdout_buffered = true,
      stderr_buffered = true,
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("`sudo make clean install` succeeded in " .. dir, vim.log.levels.INFO, { title = "config.h" })
        else
          vim.notify("`sudo make clean install` failed in " .. dir .. " (exit code " .. code .. ")", vim.log.levels.ERROR, { title = "config.h" })
        end
      end,
    })

    if job <= 0 then
      vim.notify("Failed to start `sudo make clean install` in " .. dir, vim.log.levels.ERROR, { title = "config.h" })
    else
      vim.notify("Running `sudo make clean install` in " .. dir .. "…", vim.log.levels.INFO, { title = "config.h" })
    end
  end,
})
