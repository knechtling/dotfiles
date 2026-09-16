local files = vim.fn.glob("packages/nvim-native/dot-config/nvim-native/**/*.lua", false, true)
assert(#files > 0, "Run make check from the dotfiles repository")
files[#files + 1] = "packages/nvim-native/dot-config/nvim-native/init.lua"
for _, file in ipairs(files) do assert(loadfile(file)) end
print("Native Lua syntax OK: " .. #files .. " files")
