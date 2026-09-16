return {
  {
    "mikesmithgh/kitty-scrollback.nvim",
    -- Debian 13 ships kitty 0.41.1, and kitty-scrollback.nvim 8.x requires
    -- kitty >= 0.43.0. v7.0.0 is the last tag supporting kitty 0.32.2-0.42.2.
    -- Drop this pin once kitty is 0.43.0 or newer.
    version = "v7.0.0",
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    opts = {},
  },
}
