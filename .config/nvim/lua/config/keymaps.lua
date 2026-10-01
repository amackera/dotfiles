local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Move lines
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
map("v", "<", "<gv", { desc = "Dedent and keep selection" })
map("v", ">", ">gv", { desc = "Indent and keep selection" })

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Elixir / Phoenix helpers
map("n", "<leader>mt", "<cmd>!mix test<cr>", { desc = "mix test (whole suite)" })
map("n", "<leader>mf", "<cmd>!mix format %<cr>", { desc = "mix format current file" })
map("n", "<leader>mc", "<cmd>!mix compile<cr>", { desc = "mix compile" })
map("n", "<leader>md", "<cmd>!mix deps.get<cr>", { desc = "mix deps.get" })
