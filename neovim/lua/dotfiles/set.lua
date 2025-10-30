vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.smartindent = true

vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = false

-- Completion

vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- Searching
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- When searching, ignore case only when the whole pattern is lowercase
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "100"

-- More natural split placement
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Highlights current line
vim.opt.cursorline = true

-- nvim-tree *strongly* recommends to disable builtin netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

if vim.loop.os_uname().sysname == "Darwin" then
	vim.opt.guifont = "Cascadia Mono:h18"
elseif vim.loop.os_uname().sysname == "Linux" then
	vim.opt.guifont = "Cascadia Mono:h12"
else
	vim.opt.guifont = "Cascadia Mono:h13"
end

vim.opt.linespace = 0

vim.opt.updatetime = 50
