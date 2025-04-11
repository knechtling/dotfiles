return {
  {
    "stevearc/conform.nvim",
    opts = {
      formattery_by_ft = {
        c = { "clang-format" },
      },
      formatters = {
        clang_format = {
          env = {
            ColumnLimit = 100,
          },
        },
      },
    },
  },
}
