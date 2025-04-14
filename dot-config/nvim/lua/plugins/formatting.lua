return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        clang_format = {
          prepend_args = { "--style=file", "--fallback-style=LLVM" },
        },
      },
    },
  },
}
