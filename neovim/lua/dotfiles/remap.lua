vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")


vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "kj", "<ESC>")

vim.keymap.set("i", "JK", "<ESC>")
vim.keymap.set("i", "KJ", "<ESC>")

vim.keymap.set("i", "Jk", "<ESC>")
vim.keymap.set("i", "Kj", "<ESC>")

vim.keymap.set("i", "jK", "<ESC>")
vim.keymap.set("i", "kJ", "<ESC>")


vim.keymap.set("n", "<C-l>", "<C-W><C-W>")

vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("v", "<C-c>", "\"+y<CR>")
vim.keymap.set("n", "<C-v>", "\"+p<CR>")

vim.keymap.set("n", "<leader>n", function ()
	vim.cmd([[nohl]])
end, {})

-- Go to tab by index with <space>num

vim.keymap.set("n", "<leader>1", "1gt")
vim.keymap.set("n", "<leader>2", "2gt")
vim.keymap.set("n", "<leader>3", "3gt")
vim.keymap.set("n", "<leader>4", "4gt")
vim.keymap.set("n", "<leader>5", "5gt")
vim.keymap.set("n", "<leader>6", "6gt")
vim.keymap.set("n", "<leader>7", "7gt")
vim.keymap.set("n", "<leader>8", "8gt")
vim.keymap.set("n", "<leader>9", "9gt")
