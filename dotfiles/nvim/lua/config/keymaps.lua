-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Create new tab with Ctrl+t
vim.keymap.set("n", "<C-t>", ":tabnew<CR>", { desc = "New tab" })

-- Your buffer keybindings
vim.keymap.set("n", "<C-n>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<C-p>", ":bprev<CR>", { desc = "Previous buffer" })
