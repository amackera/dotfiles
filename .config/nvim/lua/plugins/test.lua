return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "jfpedroza/neotest-elixir",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
    },
    keys = {
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Test nearest",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test file",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Test all",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Test last",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test summary panel",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Test output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Test output panel",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug nearest test",
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-elixir")({
            -- `--trace` keeps async test output readable in the panel
            extra_formatters = { "NeotestElixir.Formatter" },
          }),
          require("neotest-vitest")({
            filter_dir = function(name)
              return name ~= "node_modules" and name ~= "_build" and name ~= "deps"
            end,
          }),
          require("neotest-jest")({
            jestCommand = "npm test --",
            env = { CI = true },
          }),
        },
        status = { virtual_text = true },
        output = { open_on_run = false },
      })
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dap, dapui = require("dap"), require("dapui")
          dapui.setup()
          dap.listeners.after.event_initialized["dapui_config"] = dapui.open
          dap.listeners.before.event_terminated["dapui_config"] = dapui.close
          dap.listeners.before.event_exited["dapui_config"] = dapui.close
        end,
      },
    },
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step over",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
    },
    config = function()
      local dap = require("dap")

      -- ElixirLS ships a debug adapter alongside the language server.
      dap.adapters.mix_task = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/elixir-ls/debug_adapter.sh",
        args = {},
      }

      dap.configurations.elixir = {
        {
          type = "mix_task",
          name = "mix test",
          task = "test",
          taskArgs = { "--trace" },
          request = "launch",
          startApps = true, -- required so Ecto/Phoenix apps boot under the debugger
          projectDir = "${workspaceFolder}",
          requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs",
          },
        },
        {
          type = "mix_task",
          name = "phx.server",
          task = "phx.server",
          request = "launch",
          projectDir = "${workspaceFolder}",
        },
      }
    end,
  },
}
