-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Create new tab with Ctrl+t
vim.keymap.set("n", "<C-t>", ":tabnew<CR>", { desc = "New tab" })

-- Your buffer keybindings
vim.keymap.set("n", "<C-n>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<C-p>", ":bprev<CR>", { desc = "Previous buffer" })
