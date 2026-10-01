return {
  -- Render markdown tables as aligned boxes in normal mode. Everything else
  -- is left as raw text on purpose; tables are the only thing that is
  -- unreadable without help.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      heading = { enabled = false },
      code = { enabled = false },
      bullet = { enabled = false },
      checkbox = { enabled = false },
      quote = { enabled = false },
      dash = { enabled = false },
      link = { enabled = false },
      pipe_table = {
        preset = "round",
        cell = "padded",
      },
    },
  },
}
