return {
  {
    "lervag/wiki.vim",
    init = function()
      vim.g.wiki_root = "~/vimwiki/text/" -- wiki.vim configuration goes here, e.g.
    end,
  },
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "text", "gitcommit", "scratch" },
    init = function()
      vim.g.bullets_enabled_file_types = {
        "markdown",
        "text",
        "gitcommit",
        "scratch",
      }
    end,
  },
}
