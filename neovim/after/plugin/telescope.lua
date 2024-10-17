local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", builtin.find_files, {})
vim.keymap.set("n", "<leader>af", function ()
	builtin.find_files({ no_ignore = true, hidden = true })
end, {})
vim.keymap.set("n", "<leader>g", builtin.git_files, {})
vim.keymap.set("n", "<leader>s", builtin.live_grep, {})
vim.keymap.set("n", "<leader>/", builtin.live_grep, {})

-- TODO: Remove the leader. Problem: lsp-zero default mappings override <F3> when attaching lsp
vim.keymap.set("n", "<leader><F3>", builtin.current_buffer_fuzzy_find, {})

require("telescope").load_extension "file_browser"

vim.keymap.set(
	"n",
	"<leader>w",
	function()
		require("telescope").extensions.file_browser.file_browser()
	end,
	{ noremap = true }
)
