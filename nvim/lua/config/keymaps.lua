local map = vim.keymap.set

map("n", "<Esc>", "<cmd>noh<cr>")
map("n", ";", ":", { desc = "Command mode" })
map("i", "jk", "<Esc>")

map("n", "<leader>mb", "<cmd>make<cr>", { desc = "Make build" })
map("n", "<leader>mc", "<cmd>make clean<cr>", { desc = "Make clean" })
map("n", "<leader>mr", "<cmd>make run<cr>", { desc = "Make run" })

map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics (float)" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
map("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
map("n", "]e", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Next error" })
map("n", "[e", function()
	vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Previous error" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
