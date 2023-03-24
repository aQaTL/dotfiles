vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "kj", "<ESC>")

vim.keymap.set("n", "<C-l>", "<C-W><C-W>")

vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("v", "<C-c>", "\"+y<CR>")
vim.keymap.set("n", "<C-v>", "\"+p<CR>")

vim.keymap.set("n", "<leader>n", function ()
	vim.cmd([[nohl]])
end, {})

