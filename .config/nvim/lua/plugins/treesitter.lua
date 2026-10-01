local parsers = {
  -- Elixir / Phoenix
  "elixir",
  "heex",
  "eex",
  "erlang",
  -- Frontend
  "javascript",
  "typescript",
  "tsx",
  "css",
  "scss",
  "html",
  "graphql",
  -- Data / config
  "json",
  "json5",
  "yaml",
  "toml",
  "sql",
  -- Editor + misc
  "lua",
  "luadoc",
  "vim",
  "vimdoc",
  "bash",
  "regex",
  "query",
  "diff",
  "gitcommit",
  "git_rebase",
  "markdown",
  "markdown_inline",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(parsers)

      -- The `main` branch does not enable highlighting for you; opt in per buffer.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if not lang or not vim.treesitter.language.add(lang) then
            return
          end
          pcall(vim.treesitter.start, args.buf, lang)
          -- Treesitter indent is a big win in HEEx/JSX, where indentexpr is weak.
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local objects = {
        ["af"] = { "@function.outer", "Function" },
        ["if"] = { "@function.inner", "Function body" },
        ["ac"] = { "@class.outer", "Class/module" },
        ["ic"] = { "@class.inner", "Class/module body" },
        ["aa"] = { "@parameter.outer", "Argument" },
        ["ia"] = { "@parameter.inner", "Argument inner" },
      }
      for lhs, spec in pairs(objects) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(spec[1], "textobjects")
        end, { desc = spec[2] })
      end

      local move = require("nvim-treesitter-textobjects.move")
      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Previous function" })
    end,
  },

  -- Auto-close and auto-rename tags in HEEx, HTML, and JSX/TSX
  {
    "windwp/nvim-ts-autotag",
    ft = { "heex", "eex", "html", "javascriptreact", "typescriptreact", "xml", "svelte", "vue" },
    opts = {},
  },

  -- Sticky context header: invaluable in long LiveView modules
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = { max_lines = 3, multiline_threshold = 1 },
  },
}
