return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Servers installed by Mason and enabled automatically.
      local servers = {
        "lua_ls",
        "vtsls", -- TypeScript/JavaScript (React)
        "eslint",
        "tailwindcss",
        "cssls",
        "html",
        "jsonls",
        "yamlls",
      }

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        -- mason-lspconfig also reports plain CLI tools installed via Mason as
        -- "servers"; enabling those raises errors because no lsp config exists.
        automatic_enable = { exclude = { "stylua", "prettierd" } },
      })

      -- Capabilities from blink.cmp apply to every server.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities({}, false),
      })

      ---------------------------------------------------------------------
      -- Elixir
      ---------------------------------------------------------------------
      -- ElixirLS is installed by Mason but enabled explicitly here: it needs a
      -- larger set of root markers than the default so that umbrella apps
      -- attach to the umbrella root rather than each child app.
      vim.lsp.config("elixirls", {
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/elixir-ls" },
        root_markers = { "mix.exs", ".git" },
        filetypes = { "elixir", "eelixir", "heex", "surface" },
        settings = {
          elixirLS = {
            dialyzerEnabled = true,
            fetchDeps = false,
            enableTestLenses = false,
            suggestSpecs = true,
          },
        },
      })
      vim.lsp.enable("elixirls")

      ---------------------------------------------------------------------
      -- Tailwind: teach it Phoenix + React class conventions
      ---------------------------------------------------------------------
      vim.lsp.config("tailwindcss", {
        filetypes = {
          "elixir",
          "eelixir",
          "heex",
          "html",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
        },
        root_markers = {
          "tailwind.config.js",
          "tailwind.config.ts",
          "assets/tailwind.config.js", -- Phoenix layout
          "assets/css/app.css", -- Tailwind v4 CSS-first config
          "postcss.config.js",
          "mix.exs",
          "package.json",
        },
        settings = {
          tailwindCSS = {
            includeLanguages = {
              elixir = "html-eex",
              eelixir = "html-eex",
              heex = "html-eex",
            },
            experimental = {
              classRegex = {
                -- HEEx: class="..." and class={...}
                'class[:]\\s*"([^"]*)"',
                'class=&"([^"]*)"',
                'class=\\{"([^"]*)"\\}',
                -- Elixir: assigns/functions returning class strings
                '~H""".*class="([^"]*)".*"""',
                -- React: clsx / cva / cn helpers
                { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
              },
            },
          },
        },
      })

      ---------------------------------------------------------------------
      -- TypeScript / React
      ---------------------------------------------------------------------
      vim.lsp.config("vtsls", {
        settings = {
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              parameterNames = { enabled = "literals" },
              variableTypes = { enabled = false },
              functionLikeReturnTypes = { enabled = true },
            },
          },
          vtsls = {
            experimental = { completion = { enableServerSideFuzzyMatch = true } },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      ---------------------------------------------------------------------
      -- Buffer-local keymaps, set when a server attaches
      ---------------------------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "grn", vim.lsp.buf.rename, "Rename symbol")
          map({ "n", "v" }, "gra", vim.lsp.buf.code_action, "Code action")
          map("n", "grr", vim.lsp.buf.references, "References")
          map("n", "gri", vim.lsp.buf.implementation, "Implementation")
          map("n", "grd", vim.lsp.buf.definition, "Definition")
          map("n", "grt", vim.lsp.buf.type_definition, "Type definition")
          map("n", "K", function()
            vim.lsp.buf.hover({ border = "rounded" })
          end, "Hover docs")
          map("i", "<C-s>", function()
            vim.lsp.buf.signature_help({ border = "rounded" })
          end, "Signature help")

          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            map("n", "<leader>ch", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, "Toggle inlay hints")
          end
        end,
      })
    end,
  },
}
