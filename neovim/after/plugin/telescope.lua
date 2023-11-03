local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", builtin.find_files, {})
vim.keymap.set("n", "<leader>g", builtin.git_files, {})
vim.keymap.set("n", "<leader>s", builtin.live_grep, {})
vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
vim.keymap.set("n", "<F3>", builtin.live_grep, {})

require("telescope").load_extension "file_browser"

vim.keymap.set(
	"n",
	"<leader>n",
	function()
		require("telescope").extensions.file_browser.file_browser()
	end,
	{ noremap = true }
)
