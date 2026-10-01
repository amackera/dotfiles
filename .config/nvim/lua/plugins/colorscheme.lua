return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
      on_highlights = function(hl, c)
        -- HEEx: make component tags (<.button>, <Layouts.app>) stand apart from
        -- plain HTML tags, and keep phx-* attributes readable against the bg.
        hl["@tag.heex"] = { fg = c.red }
        hl["@tag.builtin.heex"] = { fg = c.magenta, bold = true }
        hl["@tag.attribute.heex"] = { fg = c.teal, italic = true }
        hl["@tag.delimiter.heex"] = { fg = c.blue7 }

        -- Elixir sigils and module attributes
        hl["@string.special.symbol.elixir"] = { fg = c.teal }
        hl["@variable.member.elixir"] = { fg = c.cyan }

        -- JSX/TSX parity with the HEEx colors above
        hl["@tag.tsx"] = { fg = c.red }
        hl["@tag.attribute.tsx"] = { fg = c.teal, italic = true }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-moon")
    end,
  },
}
