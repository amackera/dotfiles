return {
  -- `end` auto-insertion for do/fn/if blocks. Treesitter-aware, so it does not
  -- fire inside strings or ~H sigils.
  {
    "RRethy/nvim-treesitter-endwise",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- Phoenix project navigation: jump between controller/view/template/test,
  -- and between a LiveView and its components.
  {
    "andyl/vim-projectionist-elixir",
    ft = { "elixir", "eelixir", "heex" },
    dependencies = { "tpope/vim-projectionist" },
    keys = {
      { "<leader>ja", "<cmd>A<cr>", desc = "Alternate file (impl <-> test)" },
      { "<leader>jc", "<cmd>Econtroller<cr>", desc = "Jump to controller" },
      { "<leader>jl", "<cmd>Eliveview<cr>", desc = "Jump to live view" },
      { "<leader>jt", "<cmd>Etemplate<cr>", desc = "Jump to template" },
      { "<leader>js", "<cmd>Eschema<cr>", desc = "Jump to schema" },
      { "<leader>jm", "<cmd>Emigration<cr>", desc = "Jump to migration" },
    },
  },

  -- Structural editing for Elixir's block syntax
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
}
