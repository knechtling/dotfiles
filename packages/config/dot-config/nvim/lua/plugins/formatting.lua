return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        clang_format = {
          prepend_args = { "--style=Microsoft" },
        },
      },
      formatters_by_ft = {
        c = { "clang_format" },
        h = { "clang_format" },
      },
    },
  },
}
